output "glue_databases" {
  value = aws_glue_catalog_database.db[*].name
}
