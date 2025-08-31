variable "athena_workgroup_name" {
  description = "Athena Workgroup name"
  type        = string
  default     = "primary"
}

variable "bucket_name" {
  description = "Antena output logs"
  type        = string 
}


variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}