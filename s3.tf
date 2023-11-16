#Resource to create s3 bucket
resource "aws_s3_bucket" "deham9-secret-bucket" {
  bucket = "deham9-secret-bucket"


  tags = {
    Name = "S3Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "deham9-secret-bucket" {
  bucket = aws_s3_bucket.deham9-secret-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}