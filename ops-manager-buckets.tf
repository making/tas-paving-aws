resource "random_integer" "ops_manager_bucket_suffix" {
  min = 1
  max = 100000
}

resource "aws_s3_bucket" "ops-manager-bucket" {
  bucket        = "${var.environment_name}-ops-manager-bucket-${random_integer.ops_manager_bucket_suffix.result}"
  force_destroy = true
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-ops-manager-bucket-${random_integer.ops_manager_bucket_suffix.result}" },
  )
}

resource "aws_s3_bucket_versioning" "ops-manager-bucket" {
  bucket = aws_s3_bucket.ops-manager-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}