resource "aws_s3_bucket" "backend" {
  bucket = format("%s-%s-tf-state", var.tags["environment"], var.tags["project"])
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  depends_on = [aws_s3_bucket.backend]
  bucket     = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf-state-lock" {
  name           = format("%s-%s-tf-state-lock", var.tags["environment"], var.tags["project"])
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = var.tags
}

