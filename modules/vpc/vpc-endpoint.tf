# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)
  vpc_endpoint_type = "Gateway"

  tags = merge(var.tags, {
    Name = format("%s-%s-s3-endpoint", var.tags["environment"], var.tags["project"])
  })
}

# DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)
  vpc_endpoint_type = "Gateway"

  tags = merge(var.tags, {
    Name = format("%s-%s-dynamodb-endpoint", var.tags["environment"], var.tags["project"])
  })
}
