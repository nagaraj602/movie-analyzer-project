#!/usr/bin/env bash
# ==============================================================================
# Automated Database Initialization (Zero Bastion SSH / Headless)
# Supports two modes:
#   1. kubernetes  - Deploys a self-terminating Job inside EKS (Recommended)
#   2. ssm         - Executes commands on the bastion instance via AWS Systems Manager
# ==============================================================================
set -euo pipefail

MODE="${1:-kubernetes}"
RDS_HOST="${2:-${RDS_ENDPOINT:-}}"
MASTER_PASSWORD="${3:-${RDS_PASSWORD:-postgres}}"
REGION="${AWS_REGION:-us-east-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INIT_SQL="${SCRIPT_DIR}/init.sql"

if [ -z "$RDS_HOST" ]; then
  echo "Usage: $0 [kubernetes|ssm] <RDS_HOST_OR_ENDPOINT> [MASTER_PASSWORD]"
  echo "Example:"
  echo "  $0 kubernetes mydb.cxxxxxxx.us-east-1.rds.amazonaws.com postgres"
  echo "  $0 ssm mydb.cxxxxxxx.us-east-1.rds.amazonaws.com postgres"
  exit 1
fi

case "$MODE" in
  kubernetes|k8s)
    echo "=========================================================="
    echo " Automating DB Initialization via Kubernetes Job (EKS) "
    echo "=========================================================="
    
    # 1. Create or update ConfigMap with RDS host and port
    kubectl create configmap db-init-config \
      --from-literal=DB_HOST="${RDS_HOST%%:*}" \
      --from-literal=DB_PORT="5432" \
      --from-literal=DB_MASTER_USER="postgres" \
      --dry-run=client -o yaml | kubectl apply -f -

    # 2. Create or update Secret with master password
    kubectl create secret generic db-init-secret \
      --from-literal=DB_MASTER_PASSWORD="${MASTER_PASSWORD}" \
      --dry-run=client -o yaml | kubectl apply -f -

    # 3. Mount init.sql as a ConfigMap
    kubectl create configmap movie-analyzer-init-sql \
      --from-file=init.sql="${INIT_SQL}" \
      --dry-run=client -o yaml | kubectl apply -f -

    # 4. Clean up any previous completed/failed init jobs
    kubectl delete job movie-analyzer-db-init --ignore-not-found=true

    # 5. Apply the initialization Job
    kubectl apply -f "${SCRIPT_DIR}/k8s-db-init-job.yaml"

    # 6. Wait for job completion and show logs
    echo "Waiting for DB initialization job to complete..."
    kubectl wait --for=condition=complete --timeout=180s job/movie-analyzer-db-init
    kubectl logs job/movie-analyzer-db-init
    echo "Database initialization completed successfully via Kubernetes!"
    ;;

  ssm)
    echo "=========================================================="
    echo " Automating DB Initialization via AWS SSM Run Command "
    echo " (Zero SSH / No Bastion Login Required) "
    echo "=========================================================="
    
    BASTION_ID=$(aws ec2 describe-instances \
      --region "$REGION" \
      --filters "Name=tag:Name,Values=bastion-host" "Name=instance-state-name,Values=running" \
      --query "Reservations[0].Instances[0].InstanceId" \
      --output text)

    if [ -z "$BASTION_ID" ] || [ "$BASTION_ID" = "None" ]; then
      echo "Error: No running bastion instance found with tag Name=bastion-host."
      exit 1
    fi

    echo "Found Bastion Instance: $BASTION_ID"
    
    # Base64 encode the SQL to avoid escaping issues
    ENCODED_SQL=$(base64 -w 0 "$INIT_SQL")

    COMMAND_ID=$(aws ssm send-command \
      --region "$REGION" \
      --instance-ids "$BASTION_ID" \
      --document-name "AWS-RunShellScript" \
      --comment "Automated DB Initialization" \
      --parameters commands="[
        \"echo '${ENCODED_SQL}' | base64 -d > /tmp/init.sql\",
        \"PGPASSWORD='${MASTER_PASSWORD}' psql -h '${RDS_HOST%%:*}' -p 5432 -U postgres -d postgres -f /tmp/init.sql\",
        \"rm -f /tmp/init.sql\"
      ]" \
      --query "Command.CommandId" \
      --output text)

    echo "Dispatched SSM Command ID: $COMMAND_ID"
    echo "Waiting for command execution to finish..."
    
    aws ssm wait command-executed \
      --region "$REGION" \
      --command-id "$COMMAND_ID" \
      --instance-id "$BASTION_ID"

    OUTPUT=$(aws ssm get-command-invocation \
      --region "$REGION" \
      --command-id "$COMMAND_ID" \
      --instance-id "$BASTION_ID" \
      --query "StandardOutputContent" \
      --output text)

    echo "SSM Command Output:"
    echo "$OUTPUT"
    echo "Database initialization completed successfully via AWS SSM!"
    ;;

  *)
    echo "Error: Unknown mode '$MODE'. Supported modes are 'kubernetes' or 'ssm'."
    exit 1
    ;;
esac
