
module "data_lake_buckets" {
  source = "../../modules/s3"
  bucket_names = var.bucket_names # list of 7 bucket names
  enable_versioning = true
  tags = var.tags
}

module "iam_role" {
  source = "../../modules/iam"
  bucket_names = module.data_lake_buckets.bucket_names
  role_name    = var.role_name
  tags = var.tags
}

module "glue_catalogs" {
  source = "../../modules/glue"
  database_names = var.database_names # list of 7 db names
  iam_role_arn = module.iam_role.glue_role_arn
  bucket_mapping = module.data_lake_buckets.bucket_names
}


#module "athena" {
#  source = "../../modules/athena"
#  database_names = var.database_names
#  bucket_name = module.data_lake_buckets.bucket_names["athena-output-qc"]
#  sample_query = "SELECT 1 as test;"
#}