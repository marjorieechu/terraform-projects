variable "aws_region" {
  type = string
}

variable "runtime" {
  type = string
}

variable "timeout" {
  type = number
}

variable "schedule_expression" {
  type = string
}

variable "tags" {
  type = map(string)
}
