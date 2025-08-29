variable "bucket_names" { 
    type = list(string) 
    description = "List of S3 bucket names (7 for data lake)." 
    } 
variable "kms_key_id" { 
    type = string 
    description = "KMS key ID for bucket encryption." 
    } 
variable "enable_versioning" { 
    type = bool 
    default = true 
    description = "Enable versioning on the buckets." 
    } 
variable "tags" { 
    type = map(string) 
    default = {} 
    description = "Tags to apply to all resources." 
    }