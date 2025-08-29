##################################### Glue IAM Role #################################################################
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

######################################## Attach Managed Policies #####################################################

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

#########################
# Inline Policy - S3 
#########################

resource "aws_iam_policy" "this" {
  name        = "${var.role_name}-policy"
  description = "Custom policy for Glue to access S3 and Athena"
  policy      = data.aws_iam_policy_document.custom.json
}

data "aws_iam_policy_document" "custom" {
  statement {
    sid    = "S3Access"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = flatten([
      for bucket in var.bucket_names : [
        "arn:aws:s3:::${bucket}",
        "arn:aws:s3:::${bucket}/*"
      ]
    ])
  }

  statement {
    sid    = "GlueCatalog"
    effect = "Allow"
    actions = [
      "glue:GetDatabase",
      "glue:GetDatabases",
      "glue:GetTable",
      "glue:GetTables",
      "glue:CreateTable",
      "glue:UpdateTable",
      "glue:DeleteTable",
      "glue:GetPartition",
      "glue:CreatePartition",
      "glue:DeletePartition"
    ]
    resources = ["*"] 
  }
}

resource "aws_iam_role_policy_attachment" "custom_attach" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
