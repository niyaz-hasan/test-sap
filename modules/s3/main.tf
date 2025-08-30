############## DATA SOURCE ##################

data "aws_caller_identity" "this" {}

data "aws_region" "this" {}

locals {
  account_id = data.aws_caller_identity.this.account_id
  region     = var.region == "" ? data.aws_region.this.name : var.region
}

#####################################  S3 Buckets #################################################

resource "aws_s3_bucket" "data_lake" {
  for_each = toset(var.bucket_names)

  bucket = each.value
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 30
    }
  }

  versioning {
    enabled = var.enable_versioning
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "block" {
  for_each = aws_s3_bucket.data_lake

  bucket = each.value.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
