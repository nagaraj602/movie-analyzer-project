variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A short name/prefix for all resources"
  type        = string
  default     = "movie"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Environment = "dev"
  }
}

variable "jenkins_master_ami" {
  description = "AMI ID to use for Jenkins master EC2 instance"
  type        = string
  default     = "ami-0d97d7f07b25dd693"
}

variable "jenkins_worker_ami" {
  description = "AMI ID to use for Jenkins worker EC2 instance"
  type        = string
  default     = "ami-0d97d7f07b25dd693"
}

variable "jenkins_acm_cert_arn" {
  description = "Existing ACM certificate ARN for Jenkins ALB"
  type        = string
  default     = "arn:aws:acm:ap-south-1:070797855002:certificate/1b1ab1c4-6df7-402d-8a81-a2d700fd50ee"
}

variable "bastion_ami" {
  description = "AMI to use for the bastion host"
  type        = string
  default     = "ami-0d97d7f07b25dd693"
}

variable "bastion_ssh_key_name" {
  description = "Name of the EC2 KeyPair for SSH access to the bastion."
  type        = string
  default     = null
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "moviereviews"
}