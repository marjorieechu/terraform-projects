variable "ecr_repository_names" {
  type = list(string)
}

variable "tags" {
  type = map(any)
}

variable "aws_region" {
  type = string
}

variable "force_delete" {
  type = bool
}
