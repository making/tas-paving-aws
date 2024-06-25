resource "aws_route_table_association" "route-tas-subnet" {
  count = length(var.availability_zones)
  subnet_id = element(aws_subnet.tas-subnet[*].id, count.index)
  route_table_id = element(aws_route_table.deployment[*].id, count.index)
}
