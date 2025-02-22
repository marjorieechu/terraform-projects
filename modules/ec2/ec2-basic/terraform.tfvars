aws_region                    = "us-east-1"
ec2_instance_ami              = "ami-0e86e20dae9224db8"
ec2_instance_type             = "t2.micro"
create_on_public_subnet       = true
instance_name                 = "bastion-host"
root_volume_size              = 10
enable_termination_protection = false
ec2_instance_key_name         = "terraform-aws"
sg_name                       = "bastion-host"
allowed_ports                 = [22]
tags = {
  "owner"          = "EK TECH SOFTWARE SOLUTION"
  "environment"    = "dev"
  "project"        = "del"
  "create_by"      = "Terraform"
  "cloud_provider" = "aws"
}