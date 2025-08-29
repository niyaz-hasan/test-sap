output "bucket_ids" {
  value =  aws_s3_bucket.data_lake[*].id
}

output "bucket_arns" {
  value = aws_s3_bucket.data_lake[*].arn
}
