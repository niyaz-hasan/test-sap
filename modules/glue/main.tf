######################## locals ########################
# Create a map from database_name => bucket_name
locals {
  db_bucket_map = {
    for idx, db_name in var.database_names :
    db_name => var.bucket_mapping[idx]
  }
}

################################### glue catalog database #########################################################

resource "aws_glue_catalog_database" "db" {
  for_each = toset(var.database_names)

  name        = each.value
  description = "Glue DB for ${each.value}"
  parameters  = var.parameters
}


################################# glue crawler #########################################################################

resource "aws_glue_crawler" "crawler" {
  for_each = local.db_bucket_map

  name          = "${each.key}-crawler"
  database_name = aws_glue_catalog_database.db[each.key].name
  role          = var.iam_role_arn

  s3_target {
    path = "s3://${each.value}/"
  }
}