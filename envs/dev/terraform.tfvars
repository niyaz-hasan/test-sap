region          = "us-east-1"

bucket_names    = ["dev-bkt-a", "dev-bkt-b"]

database_names  = ["dev-db-a", "dev-db-b"]

athena_workgroup = "primary"

role_name = "glue-role-sap"

tags = {
  env   = "dev"
}
