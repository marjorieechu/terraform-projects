variable "namespaces" {
  type = list(string)
}

variable "tags" {
  type = map(any)
}

variable "aws_region" {
  type = string
}

variable "control_plane_name" {
  type = string
}