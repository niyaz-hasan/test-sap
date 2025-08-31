# Convert database_names and bucket_names into a map for for_each
locals {
  db_map = {
    for idx, db_name in var.database_names :
    db_name => {
      name   = db_name
      bucket = var.bucket_names[idx]
    }
  }
}


################################### glue catalog database #########################################################

resource "aws_glue_catalog_database" "db" {
  for_each = local.db_map

  name        = each.value.name
  description = "Glue DB for ${each.value.name}"
  parameters  = var.parameters
}


################################# glue crawler #########################################################################

resource "aws_glue_crawler" "crawler" {
  for_each     = local.db_map
  name         = "${each.value.name}-crawler"
  database_name = aws_glue_catalog_database.db[each.key].name
  role          = var.iam_role_arn

  s3_target {
    path = "s3://${each.value.bucket}/"
  }
}