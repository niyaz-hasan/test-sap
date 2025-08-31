output "glue_databases" {
  value = [for db in aws_glue_catalog_database.db : db.name]
}