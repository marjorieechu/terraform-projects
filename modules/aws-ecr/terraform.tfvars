aws_region    = "us-east-1"
force_delete = false
ecr_repository_names = [
  "repo-01",
  "repo-02"
]

tags = {
  "owner"          = "EK TECH SOFTWARE SOLUTION"
  "environment"    = "dev"
  "project"        = "del"
  "create_by"      = "Terraform"
  "cloud_provider" = "aws"
}