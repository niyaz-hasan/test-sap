#terraform {
#  backend "s3" {
#    bucket         = "terraform-states-dev-sap"     # unique per env
#    key            = "data_lake_sap_gda/terraform.tfstate"
#    region         = "us-east-1"
#    dynamodb_table = "terraform-locks-dev"
#    encrypt        = true
#  }
#}
