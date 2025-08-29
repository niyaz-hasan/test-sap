variable "athena_workgroup_name" {
  description = "Athena Workgroup name"
  type        = string
  default     = "primary"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}