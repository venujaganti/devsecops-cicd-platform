variable "aws_region" {
  description = "AWS region where infrastructure will be created"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
  default     = "devsecops-cicd-platform"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet"
  type        = string
  default     = "ap-south-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Optional EC2 AMI ID. When empty, the latest Canonical Ubuntu 24.04 amd64 gp3 AMI is resolved from AWS SSM."
  type        = string
  default     = ""

  validation {
    condition     = var.ami_id == "" || can(regex("^ami-[a-zA-Z0-9]+$", var.ami_id))
    error_message = "ami_id must be empty or a valid AWS AMI ID such as ami-0123456789abcdef0."
  }
}

variable "key_name" {
  description = "Optional existing EC2 key pair name. Leave empty to create the instance without an SSH key."
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GB."
  }
}
