# AWS Boilerplate
provider "aws" {
  version = "~> 2.0"
  region  = "us-west-2"
}

# Requires the `Random` Provider - it is installed by `terraform init`
resource "random_string" "version" {
  length  = 8
  upper   = false
  lower   = true
  number  = true
  special = false
}

# Create an S3 bucket with a random name - Bucket names only accept lower case characters and hyphens
resource "aws_s3_bucket" "bucket_resources" {
  bucket  = "bucket-resources-${random_string.version.result}"
}

# Create a object (aka folder) in s3 bucket
resource "aws_s3_bucket_object" "folder1" {
  bucket = aws_s3_bucket.bucket_resources.id
  acl    = "private"
  key    = "Folder1/"
  source = ""
}

# Upload the contents of a local folder to an S3 bucket
# Makes sure that each file has an `etag`
# Example of the `fileset`, `filemd5`, `replace`, and `lookup` functions
resource "aws_s3_bucket_object" "bucket_resources_files" {
  for_each      = fileset("${path.cwd}/demo/", "**/*.*")
  bucket        = aws_s3_bucket.bucket_resources.bucket
  key           = replace(each.value, "${path.cwd}/bucket_resources/", "")
  source        = "${path.cwd}/bucket_resources/${each.value}"
 # etag          = filemd5("${path.cwd}/bucket-resources/${each.value}")
}

# S3 bucket with a random name
resource "aws_s3_bucket" "carvedrock_v1" {
  bucket = "carvedrock-v1-${random_string.version.result}"
}

# Create Users for Account
resource "aws_iam_user" "Sarah" {
  name = "Sarah.Sign"
  path = "/"
}

resource "aws_iam_user" "Max" {
  name = "Max.Money"
  path = "/"
}

resource "aws_iam_user" "Alice" {
  name = "Alice.Acme"
  path = "/"
}

# Create Groups for Account
resource "aws_iam_group" "my_finance" {
  name = "finance"
}

resource "aws_iam_group" "my_developers" {
  name = "developers"
}

resource "aws_iam_group" "my_admin" {
  name = "administrators"
}

# Add Users to Groups
resource "aws_iam_group_membership" "my_admin" {
  name  = "admin-group-membership"
  group = "administrators"
  users = [
    aws_iam_user.Alice.name,
  ]
}

resource "aws_iam_group_membership" "my_finance" {
  name  = "finance-group-membership"
  group = "finance"
  users = [
    aws_iam_user.Max.name,
  ]
}

resource "aws_iam_group_membership" "my_developers" {
  name  = "dev-group-membership"
  group = "developers"
  users = [
    aws_iam_user.Sarah.name,
  ]
}

# Create Policies
resource "aws_iam_group_policy" "my_developer_policy" {
  name   = "my_developer_policy"
  group  = "developers"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "ec2:*",
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_group_policy" "my_finance_policy" {
  name   = "my_finance_policy"
  group  = "finance"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY

}

resource "aws_iam_group_policy" "my_admin_policy" {
  name   = "my_admin_policy"
  group  = "administrators"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
POLICY

}