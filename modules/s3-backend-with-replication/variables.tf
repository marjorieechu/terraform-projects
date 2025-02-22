variable "aws_region_main" {
  type    = string
  default = "The AWS region where the primary Terraform state file is stored. Typically, this could be the region where the S3 bucket (used for remote state storage) is located. This ensures that Terraform operations like state locking and retrieval happen in a defined AWS region. In this case, the default is us-east-1 (North Virginia region)."
}

variable "aws_region_backup" {
  type    = string
  default = "The AWS region where a backup of the Terraform state file is stored. This is used for disaster recovery scenarios where a copy of the state file is needed in another AWS region, providing redundancy. The default is us-east-2 (Ohio region), but it can be customized as needed."
}

variable "tags" {
  type        = map(string)
  description = "A map of key-value pairs representing common tags to apply to AWS resources (such as Name, Environment). Tags help in organizing and identifying resources, especially in large-scale environments."
}

variable "force_destroy" {
  type    = bool
  description = "Determines whether to forcefully destroy the S3 bucket, including all objects, when deleting the bucket. Set to true if the bucket should be deleted even if it contains objects."
}