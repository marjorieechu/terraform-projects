# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch subnets associated with the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch the Internet Gateway attached to the VPC (gracefully handle if not found)
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch route tables associated with the VPC
data "aws_route_tables" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch security groups associated with the VPC
data "aws_security_groups" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch the default security group to exclude it from deletion
data "aws_security_group" "default_sg" {
  filter {
    name   = "group-name"
    values = ["default"]
  }
  vpc_id = data.aws_vpc.default.id
}

# Delete subnets (skip if already deleted)
resource "null_resource" "delete_subnets" {
  for_each = toset(data.aws_subnets.default.ids)

  provisioner "local-exec" {
    command = "aws ec2 delete-subnet --subnet-id ${each.value} --region ${var.region} || echo 'Subnet already deleted or does not exist.'"
  }
}

resource "null_resource" "delete_igw" {
  provisioner "local-exec" {
    command = <<EOT
      IGW_ID=$(aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=${data.aws_vpc.default.id} --region ${var.region} --query 'InternetGateways[0].InternetGatewayId' --output text)
      if [ "$IGW_ID" != "None" ]; then
        echo "Detaching and deleting IGW: $IGW_ID"
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id ${data.aws_vpc.default.id} --region ${var.region}
        aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --region ${var.region}
      else
        echo "No Internet Gateway found or already deleted."
      fi
    EOT
  }
}


# Delete route tables (skip if main route table or already deleted)
resource "null_resource" "delete_route_tables" {
  for_each = toset([for rt in data.aws_route_tables.default.ids : rt if rt != data.aws_vpc.default.main_route_table_id])

  provisioner "local-exec" {
    command = "aws ec2 delete-route-table --route-table-id ${each.value} --region ${var.region} || echo 'Route Table already deleted or does not exist.'"
  }
}

# Delete security groups (exclude default, skip if already deleted)
resource "null_resource" "delete_security_groups" {
  for_each = toset([for sg in data.aws_security_groups.default.ids : sg if sg != data.aws_security_group.default_sg.id])

  provisioner "local-exec" {
    command = "aws ec2 delete-security-group --group-id ${each.value} --region ${var.region} || echo 'Security group already deleted or does not exist.'"
  }
}

# Delete the VPC after dependencies are removed (skip if not found)
resource "null_resource" "delete_vpc" {
  provisioner "local-exec" {
    command = "aws ec2 delete-vpc --vpc-id ${data.aws_vpc.default.id} --region ${var.region} || echo 'VPC already deleted or does not exist.'"
  }
}
