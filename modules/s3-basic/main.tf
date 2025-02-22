resource "aws_s3_bucket" "backend" {
  bucket = format("%s-%s-${var.bucket_name}", var.tags["environment"], var.tags["project"])
  tags   = var.tags
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  depends_on = [aws_s3_bucket.backend]
  bucket     = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}
