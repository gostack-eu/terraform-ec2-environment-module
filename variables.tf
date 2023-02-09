variable "s3_bucket_name" {
  description = "S3 bucket name to be used for the instance environment files"
  type        = string
}

variable "instance_profile" {
  description = "Instance profile to be used for the instance"
  type        = string
}

variable "env" {
  description = "Environment variables to be set on the instance"
  type        = map(string)
  default     = {}
}

variable "files_path" {
  description = "Path to directory containing files to be copied to the instance"
  type        = string
  default     = null
}

variable "template_files" {
  description = "Map of files to be created from templates"
  # Example:
  # template_files = {
  #   "file" = templatefile("${path.module}/templates/file1.tpl", {key1 = "value1", key2 = "value2"})
  #   "directory/file" = templatefile("${path.module}/templates/file2.tpl", {key1 = "value1", key2 = "value2"})
  # }
  type    = map(string)
  default = {}
}

variable "iam_policy_tags" {
  description = "Tags to be applied to the IAM policy"
  type        = map(string)
  default     = {}
}

variable "root_dir" {
  description = "Root directory for environment files"
  type        = string
  default     = null
}
