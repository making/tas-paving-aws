resource "aws_subnet" "tas-subnet" {
  count = length(var.tas_subnet_cidrs)

  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.tas_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    var.tags,
    { Name = "${var.environment_name}-tas-subnet-${count.index}" },
  )
}
