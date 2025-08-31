variable "database_names" {
type = list(string)
description = "List of Glue database names (7 total)."
}


variable "iam_role_arn" {
type = string
description = "IAM role ARN for Glue crawlers."
}


variable "bucket_mapping" {
type = list(string)
description = "Mapping of database_name => bucket_name."
}


#variable "parameters" {
#type = map(string)
#default = {}
#description = "Additional parameters for Glue databases."
#}