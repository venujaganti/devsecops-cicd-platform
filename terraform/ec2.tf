resource "aws_instance" "main" {
  ami                         = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.ubuntu_ami.value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  key_name                    = var.key_name != "" ? var.key_name : null
  associate_public_ip_address = true

  user_data = file("${path.module}/user-data.sh")

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2"
      Role = "DevSecOps"
    }
  )
}