locals {
  stable_config_tas = {
    tas_subnet_ids      = aws_subnet.tas-subnet[*].id
    tas_subnet_cidrs    = aws_subnet.tas-subnet[*].cidr_block
    tas_subnet_gateways = [
      for i in range(length(var.availability_zones)) :
      cidrhost(aws_subnet.tas-subnet[i].cidr_block, 1)
    ]
    tas_subnet_reserved_ip_ranges = [
      for i in range(length(var.availability_zones)) :
      "${cidrhost(aws_subnet.tas-subnet[i].cidr_block, 1)}-${cidrhost(aws_subnet.tas-subnet[i].cidr_block, 9)}"
    ]

    buildpacks_bucket_name                  = aws_s3_bucket.buildpacks-bucket.bucket
    droplets_bucket_name                    = aws_s3_bucket.droplets-bucket.bucket
    packages_bucket_name                    = aws_s3_bucket.packages-bucket.bucket
    resources_bucket_name                   = aws_s3_bucket.resources-bucket.bucket
    tas_blobstore_iam_instance_profile_name = aws_iam_instance_profile.tas-blobstore.name

    ssh_lb_security_group_id   = aws_security_group.ssh-lb.id
    ssh_lb_security_group_name = aws_security_group.ssh-lb.name
    ssh_target_group_name      = aws_lb_target_group.ssh.name

    web_lb_security_group_id   = aws_security_group.web-lb.id
    web_lb_security_group_name = aws_security_group.web-lb.name
    web_target_group_names = [
      aws_lb_target_group.web-80.name,
      aws_lb_target_group.web-443.name
    ]

    mysql_security_group_id   = aws_security_group.mysql.id
    mysql_security_group_name = aws_security_group.mysql.name

    sys_dns_domain = replace(aws_route53_record.wildcard-sys.name, "*.", "")
    apps_dns_domain = replace(aws_route53_record.wildcard-apps.name, "*.", "")
    ssh_dns = aws_route53_record.ssh.name
  }
}

output "stable_config_tas" {
  value = jsonencode(local.stable_config_tas)
  sensitive = true
}
