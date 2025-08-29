variable "database_names" {
type = list(string)
description = "List of Athena database names (7 total)."
}


variable "bucket_mapping" {
type = map(string)
description = "Mapping of database_name => bucket_name for query results."
}


variable "sample_query" {
type = string
default = "SELECT 1;"
description = "Sample query for Athena."
}