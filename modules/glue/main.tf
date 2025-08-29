resource "aws_glue_catalog_database" "db" {
  count = length(var.database_names)

  name        = var.database_names[count.index]
  description = "Glue DB for ${var.database_names[count.index]}"
  parameters  = var.parameters
}

resource "aws_glue_crawler" "crawler" {
  count        = length(var.database_names)
  name         = "${var.database_names[count.index]}-crawler"
  database_name = aws_glue_catalog_database.db[count.index].name
  role          = var.iam_role_arn

  s3_target {
    path = "s3://${var.bucket_names[count.index]}/"
  }
}
