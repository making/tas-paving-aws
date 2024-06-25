data "aws_iam_policy_document" "tas-blobstore-policy" {
  statement {
    sid    = "PasBlobstorePolicy"
    effect = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.buildpacks-bucket.arn,
      "${aws_s3_bucket.buildpacks-bucket.arn}/*",
      aws_s3_bucket.packages-bucket.arn,
      "${aws_s3_bucket.packages-bucket.arn}/*",
      aws_s3_bucket.resources-bucket.arn,
      "${aws_s3_bucket.resources-bucket.arn}/*",
      aws_s3_bucket.droplets-bucket.arn,
      "${aws_s3_bucket.droplets-bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "tas-blobstore" {
  name   = "${var.environment_name}-tas-blobstore-policy"
  policy = data.aws_iam_policy_document.tas-blobstore-policy.json
}

resource "aws_iam_role_policy_attachment" "tas-blobstore" {
  role       = aws_iam_role.tas-blobstore.name
  policy_arn = aws_iam_policy.tas-blobstore.arn
}

resource "aws_iam_instance_profile" "tas-blobstore" {
  name = "${var.environment_name}-tas-blobstore"
  role = aws_iam_role.tas-blobstore.name
  lifecycle {
    ignore_changes = [name]
  }
}
