##################### OUTPUTS #####################

# Output all bucket ARNs as a map (bucket_name => ARN)
output "bucket_arns" {
  value = {
    for k, b in aws_s3_bucket.data_lake : k => b.arn
  }
}

# Output all bucket names as a list
output "bucket_names" {
  value = [for b in aws_s3_bucket.data_lake : b.bucket]
}

# Output all bucket IDs as a map (bucket_name => ID)
output "bucket_ids" {
  value = {
    for k, b in aws_s3_bucket.data_lake : k => b.id
  }
}
