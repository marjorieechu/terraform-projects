resource "aws_instance" "vm" {
  ami                     = var.ec2_instance_ami
  instance_type           = var.ec2_instance_type
  key_name                = var.ec2_instance_key_name
  vpc_security_group_ids  = [aws_security_group.sg.id]
  subnet_id               = var.create_on_public_subnet ? var.public_subnet[0] : var.private_subnet[0]
  disable_api_termination = var.enable_termination_protection

  root_block_device {
    volume_size = var.root_volume_size
  }

  tags = merge(var.tags, {
    Name = format("%s-%s-${var.instance_name}", var.tags["environment"], var.tags["project"])
    },
  )
}

resource "aws_eip" "instance_eip" {
  count    = var.create_on_public_subnet ? 1 : 0
  instance = aws_instance.vm.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = format("%s-%s-${var.instance_name}", var.tags["environment"], var.tags["project"])
    },
  )
}