variable "bucket_names" {
type = list(string)
description = "List of 7 S3 bucket names."
}

variable "database_names" {
type = list(string)
description = "List of 7 Glue/Athena database names."
}

variable "glue_service_role_arn" {
type = string
description = "IAM role ARN for Glue crawlers."
}

variable "tags" {
type = map(string)
default = {}
description = "Tags to apply to resources."
}

variable "role_name" {
  type = string
  default = {}
}

variable "region" {
type = string
default = "us-east-1"
}