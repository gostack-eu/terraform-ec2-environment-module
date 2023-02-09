locals {
  root_dir = var.root_dir == null ? var.instance_profile : var.root_dir
  s3_root  = "ec2/${local.root_dir}"
  count    = var.s3_bucket_name != null ? 1 : 0
}
