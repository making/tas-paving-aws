resource "aws_eip" "ops-manager" {
  domain = "vpc"
  tags = merge(
    var.tags,
    { "Name" = "${var.environment_name}-ops-manager-eip" },
  )
}

resource "aws_key_pair" "ops-manager" {
  key_name   = "${var.environment_name}-ops-manager-key"
  public_key = tls_private_key.ops-manager.public_key_openssh
}

resource "tls_private_key" "ops-manager" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_iam_policy" "ops-manager-role" {
  name   = "${var.environment_name}-ops-manager-role"
  policy = data.aws_iam_policy_document.ops-manager.json
}

resource "aws_iam_role_policy_attachment" "ops-manager-policy" {
  role       = aws_iam_role.ops-manager.name
  policy_arn = aws_iam_policy.ops-manager-role.arn
}

resource "aws_iam_role" "ops-manager" {
  name = "${var.environment_name}-ops-manager-role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ops-manager" {
  name = "${var.environment_name}-ops-manager"
  role = aws_iam_role.ops-manager.name

  lifecycle {
    ignore_changes = [name]
  }
}

data "aws_iam_policy_document" "ops-manager" {
  statement {
    sid    = "OpsMgrInfoAboutCurrentInstanceProfile"
    effect = "Allow"
    actions = ["iam:GetInstanceProfile"]
    resources = [aws_iam_instance_profile.ops-manager.arn]
  }

  statement {
    sid    = "OpsMgrCreateInstanceWithCurrentInstanceProfile"
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = compact([
      aws_iam_role.ops-manager.arn,
      aws_iam_role.tas-blobstore.arn
    ])
  }

  statement {
    sid    = "OpsMgrS3Permissions"
    effect = "Allow"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.ops-manager-bucket.arn,
      "${aws_s3_bucket.ops-manager-bucket.arn}/*"
    ]
  }

  statement {
    sid    = "OpsMgrEC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:DescribeKeypairs",
      "ec2:DescribeVpcs",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeImages",
      "ec2:DeregisterImage",
      "ec2:DescribeSubnets",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:DescribeInstances",
      "ec2:TerminateInstances",
      "ec2:RebootInstances",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "ec2:DescribeAddresses",
      "ec2:DisassociateAddress",
      "ec2:AssociateAddress",
      "ec2:CreateTags",
      "ec2:DescribeVolumes",
      "ec2:CreateVolume",
      "ec2:AttachVolume",
      "ec2:DeleteVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:CreateSnapshot",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:DescribeRegions",
      "ec2:CancelSpotInstanceRequests",
      "ec2:DescribeSpotInstanceRequests",
      "ec2:RequestSpotInstances"
    ]
    resources = ["*"]
  }
}

// NOTE: here because it gets consumed by the opsmanager policy
resource "aws_iam_role" "tas-blobstore" {
  name = "${var.environment_name}-tas-blobstore"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": [
        "sts:AssumeRole"
      ]
    }
  ]
}
EOF
}