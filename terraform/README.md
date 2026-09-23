# Terraform Infrastructure

This directory contains the Terraform configuration for provisioning
the AWS infrastructure required by the DevSecOps CI/CD Platform.

## Infrastructure

Terraform creates:

- 1 VPC
- 1 Internet Gateway
- 1 public subnet
- 1 public route table
- 1 route table association
- 1 security group
- 1 EC2 instance
- 1 encrypted gp3 root volume

## Project Structure

```text
terraform/
├── versions.tf
├── ami.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── vpc.tf
├── security-group.tf
├── ec2.tf
├── user-data.sh
├── outputs.tf
├── locals.tf
├── .gitignore
└── README.md
```

## AMI and SSH key configuration

If `ami_id` is left empty, Terraform resolves the current Canonical Ubuntu 24.04 amd64 gp3 AMI through the AWS public SSM parameter.

`key_name` is optional. Set it to an existing EC2 key pair name when SSH access is required.
