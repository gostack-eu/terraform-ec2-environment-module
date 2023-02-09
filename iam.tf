data "aws_iam_policy_document" "this" {
  count = local.count
  statement {
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      data.aws_s3_bucket.this[0].arn
    ]
  }
  statement {
    actions = [
      "s3:GetObject"
    ]
    resources = [
      data.aws_s3_bucket.this[0].arn,
      "${data.aws_s3_bucket.this[0].arn}/${local.s3_root}/*"
    ]
  }
}

resource "aws_iam_policy" "this" {
  count  = local.count
  name   = "${replace(local.root_dir, "/", "-")}-${var.s3_bucket_name}"
  policy = data.aws_iam_policy_document.this[0].json
  tags   = var.iam_policy_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.count
  role       = data.aws_iam_instance_profile.this[0].role_name
  policy_arn = aws_iam_policy.this[0].arn
}
