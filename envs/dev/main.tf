module "data_lake_buckets" {
source = "../../modules/s3"
bucket_names = var.bucket_names # list of 7 bucket names
kms_key_id = var.kms_key_id
enable_versioning = true
tags = var.tags
}


module "glue_catalogs" {
source = "../../modules/glue"
database_names = var.database_names # list of 7 db names
iam_role_arn = var.glue_service_role_arn
bucket_mapping = zipmap(var.database_names, var.bucket_names)
}


module "athena" {
source = "../../modules/athena"
database_names = var.database_names
bucket_mapping = zipmap(var.database_names, var.bucket_names)
sample_query = "SELECT 1 as test;"
}