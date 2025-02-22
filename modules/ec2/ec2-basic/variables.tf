# Define string variables
variable "aws_region" {
  type        = string
  description = "The AWS region where resources will be created"
}

variable "ec2_instance_ami" {
  type        = string
  description = "The AMI ID to be used for the EC2 instance"
}

variable "create_on_public_subnet" {
  type        = bool
  description = "Whether the instance should be created in a public subnet"
}

variable "ec2_instance_type" {
  type        = string
  description = "The instance type to be used for the EC2 instance (e.g., t2.micro)"
}

variable "root_volume_size" {
  type        = string
  description = "The size of the root volume in GiB for the EC2 instance"
}

variable "instance_name" {
  type        = string
  description = "The name to assign to the EC2 instance"
}

variable "ec2_instance_key_name" {
  type        = string
  description = "The key pair name to use for the EC2 instance"
}

variable "enable_termination_protection" {
  type        = bool
  description = "Enable or disable termination protection for the EC2 instance"
}

variable "sg_name" {
  type        = string
  description = "The name of the security group"
}

variable "allowed_ports" {
  type        = list(number)
  description = "A list of allowed ports for the security group"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to apply to the resources"
}

variable "vpc_id" {
  type        = string
  description = ""
}

variable "private_subnet" {
  type        = list(string)
  description = ""
}

variable "public_subnet" {
  type        = list(string)
  description = ""
}
