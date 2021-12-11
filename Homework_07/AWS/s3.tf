
# allow access to s3 from ec2
resource "aws_iam_role" "role_ec2_s3" {
  name_prefix = "${var.prefix}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = {
    tag-key = "${var.prefix}role_ec2_s3"
  }

}

# policy to allow access to s3 from ec2
resource "aws_iam_role_policy" "pol" {
  name = "policy-ec2-s3"
  role = aws_iam_role.role_ec2_s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action = [
          "s3:Get*",
          "s3:List*"
        ],
        Resource = "*"
      },
    ]
  })
}

# Create S3 bucket for web page storage
resource "aws_s3_bucket" "b" {
  bucket = "bucketrusd80"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "andersen training bucket"
    Environment = "dev"
  }
}

# define index.html as object available by key
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "index.html"
  source = "index.html"
  etag = filemd5("index.html")
}
