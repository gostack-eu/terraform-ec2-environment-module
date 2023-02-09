output "s3_environment_path" {
  description = "This is the path in S3 where the environment files are stored"
  value       = local.count == 1 ? "${var.s3_bucket_name}/${local.s3_root}/" : ""
}


output "instance_tags" {
  description = "For backwards compatibility. Usage:\n`tags = module.s3_environment.instance_tags`"
  value       = local.count == 1 ? { S3_ENVIRONMENT_PATH = "${var.s3_bucket_name}/${local.s3_root}/" } : {}
}
