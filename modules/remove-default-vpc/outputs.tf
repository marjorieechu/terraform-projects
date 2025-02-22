output "deleted_vpc_resources" {
  description = "List of deleted resources associated with the default VPC."
  value = {
    vpc_id            = data.aws_vpc.default.id
    subnets_deleted   = data.aws_subnets.default.ids
    route_tables      = data.aws_route_tables.default.ids
    security_groups   = data.aws_security_groups.default.ids
    internet_gateways = [data.aws_internet_gateway.default.id]
  }
}
