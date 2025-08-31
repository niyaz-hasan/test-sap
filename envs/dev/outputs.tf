output "bucket_arns" {
    value = module.data_lake_buckets.bucket_arns
}
output "bucket_names" {
    value = module.data_lake_buckets.bucket_names
}
output "bucket_ids" {
    value = module.data_lake_buckets.bucket_ids
}

output "glue_databases" {
  value = module.glue_catalogs.glue_databases
}

output "glue_role_arn" {
  value = module.iam_role.glue_role_arn
}

output "glue_role_name" {
  value = module.iam_role.glue_role_name
}