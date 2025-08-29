variable "role_name" {
  description = "Name of the Glue IAM role"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name Glue should access"
  type        = list(string)
}

variable "tags" {
  description = "Tags for Glue IAM role"
  type        = map(string)
  default     = {}
}
