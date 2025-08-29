region          = "us-east-1"

bucket_names    = ["dev-bkt-a", "dev-bkt-b", "dev-bkt-c", "dev-bkt-d", "dev-bkt-e", "dev-bkt-f", "dev-bkt-g"]

database_names  = ["dev-db-a", "dev-db-b", "dev-db-c", "dev-db-d", "dev-db-e", "dev-db-f", "dev-db-g"]

glue_service_role_arn = "arn:aws:iam::111122223333:role/dev-glue-role"

athena_workgroup = "dev-data-workgroup"

tags = {
  env   = "dev"
  owner = "data-team"
}
