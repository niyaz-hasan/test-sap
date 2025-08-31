region          = "us-east-1"

bucket_names    = ["dev-bkt-a", "dev-bkt-b", "dev-bkt-c", "dev-bkt-d", "dev-bkt-e", "dev-bkt-f", "dev-bkt-g"]

database_names  = ["dev-db-a", "dev-db-b", "dev-db-c", "dev-db-d", "dev-db-e", "dev-db-f", "dev-db-g"]

athena_workgroup = "primary"

role_name = "glue-role-sap"

tags = {
  env   = "dev"
}
