resource "aws_s3_object" "env" {
  count   = local.count
  bucket  = var.s3_bucket_name
  key     = "${local.s3_root}/.env"
  content = <<EOT
%{for key, value in var.env~}
${key}="${value}"
%{endfor~}
EOT
}

resource "aws_s3_object" "files" {
  for_each    = var.files_path == null ? toset([]) : fileset(var.files_path, "**")
  bucket      = var.s3_bucket_name
  key         = "${local.s3_root}/${each.key}"
  source      = "${var.files_path}/${each.key}"
  source_hash = filemd5("${var.files_path}/${each.key}")
  lifecycle {
    ignore_changes = [
      source
    ]
  }
  depends_on = [
    aws_s3_object.env
  ]
}

resource "aws_s3_object" "templatefiles" {
  for_each = var.template_files
  bucket   = var.s3_bucket_name
  key      = "${local.s3_root}/${each.key}"
  content  = each.value
  depends_on = [
    aws_s3_object.files
  ]
}
