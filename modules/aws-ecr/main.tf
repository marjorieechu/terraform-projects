resource "aws_ecr_repository" "ecr" {
  for_each     = toset(var.ecr_repository_names)
  name         = each.key
  force_delete = var.force_delete
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}
