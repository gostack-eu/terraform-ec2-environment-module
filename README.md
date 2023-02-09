<h1>Terraform EC2 Environment Module</h1>

This module creates an IAM policy and attaches it to an IAM role. The policy allows the role to read and write to an S3 bucket. The module also creates a directory in the S3 bucket and uploads files to it. The files can be either plain text files or files created from templates. Additionally, the module creates an `.env` file containing environment variables.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment variables to be set on the instance | `map(string)` | `{}` | no |
| <a name="input_files_path"></a> [files\_path](#input\_files\_path) | Path to directory containing files to be copied to the instance | `string` | `null` | no |
| <a name="input_iam_policy_tags"></a> [iam\_policy\_tags](#input\_iam\_policy\_tags) | Tags to be applied to the IAM policy | `map(string)` | `{}` | no |
| <a name="input_instance_profile"></a> [instance\_profile](#input\_instance\_profile) | Instance profile to be used for the instance | `string` | n/a | yes |
| <a name="input_root_dir"></a> [root\_dir](#input\_root\_dir) | Root directory for environment files | `string` | `null` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 bucket name to be used for the instance environment files | `string` | n/a | yes |
| <a name="input_template_files"></a> [template\_files](#input\_template\_files) | Map of files to be created from templates | `map(string)` | `{}` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_tags"></a> [instance\_tags](#output\_instance\_tags) | For backwards compatibility. Usage:<br>`tags = module.s3_environment.instance_tags` |
| <a name="output_s3_environment_path"></a> [s3\_environment\_path](#output\_s3\_environment\_path) | This is the path in S3 where the environment files are stored |
## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_object.env](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.files](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_s3_object.templatefiles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_instance_profile) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket) | data source |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<h2>Example</h2>

```hcl
resource "aws_iam_role" "this" {
  name = "my-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
        }
    ]
}

resource "aws_iam_instance_profile" "this" {
  name = "my-instance-profile"
  role = aws_iam_role.this.name
}

resource "aws_s3_bucket" "this" {
  bucket = "my-bucket"
}

module "s3_environment" {
  source = "github.com/gostack-eu/terraform-ec2-environment"

  s3_bucket_name = aws_s3_bucket.this.id
  instance_profile = aws_iam_instance_profile.this.name
  files_path = "${path.module}/files"
  root_dir = "my-root-dir"

  template_files = {
    "my-template-file" = "my-template-file.tpl"
  }
  env = {
    MY_ENV_VAR = "my-env-var"
  }
}

resource "aws_instance" "this" {
  ami = "ami-1234567890"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name
  tags = {
    Name = "my-instance"
    S3_ENVIRONMENT_PATH = module.s3_environment.s3_environment_path
  }
}
```
