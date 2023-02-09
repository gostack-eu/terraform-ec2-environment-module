data "aws_s3_bucket" "this" {
  count  = local.count
  bucket = var.s3_bucket_name
}

data "aws_iam_instance_profile" "this" {
  count = local.count
  name  = var.instance_profile
}
