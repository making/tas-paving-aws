resource "random_integer" "tas_bucket_suffix" {
  min = 1
  max = 100000
}

resource "aws_s3_bucket" "buildpacks-bucket" {
  bucket        = "${var.environment_name}-buildpacks-bucket-${random_integer.tas_bucket_suffix.result}"
  force_destroy = true
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-buildpacks-bucket-${random_integer.tas_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "buildpacks-bucket-versioning" {
  bucket = aws_s3_bucket.buildpacks-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "packages-bucket" {
  bucket        = "${var.environment_name}-packages-bucket-${random_integer.tas_bucket_suffix.result}"
  force_destroy = true
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-packages-bucket-${random_integer.tas_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "packages-bucket-versioning" {
  bucket = aws_s3_bucket.packages-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "resources-bucket" {
  bucket        = "${var.environment_name}-resources-bucket-${random_integer.tas_bucket_suffix.result}"
  force_destroy = true
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-resources-bucket-${random_integer.tas_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "resources-bucket-versioning" {
  bucket = aws_s3_bucket.resources-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "droplets-bucket" {
  bucket        = "${var.environment_name}-droplets-bucket-${random_integer.tas_bucket_suffix.result}"
  force_destroy = true
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-droplets-bucket-${random_integer.tas_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "droplets-bucket-versioning" {
  bucket = aws_s3_bucket.droplets-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}