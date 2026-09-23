output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

output "ssh_command" {
  description = "Example SSH command"
  value       = "ssh -i <your-key-file.pem> ubuntu@${aws_instance.main.public_ip}"
}

output "jenkins_url" {
  description = "Jenkins URL"
  value       = "http://${aws_instance.main.public_ip}:8080"
}

output "application_url" {
  description = "HTTP application URL"
  value       = "http://${aws_instance.main.public_ip}"
}