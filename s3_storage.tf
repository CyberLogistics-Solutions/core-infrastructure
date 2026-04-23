# This Terraform file defines a storage bucket for customer data
# VULNERABILITY 1: Public access is enabled, making the bucket accessible to the entire internet.
# VULNERABILITY 2: Hardcoded Anthropic API Key found in provider configuration.

resource "aws_s3_bucket" "customer_data_storage" {
  bucket = "cyber-logistics-customer-data-001"
}

resource "aws_s3_bucket_public_access_block" "insecure_config" {
  bucket = aws_s3_bucket.customer_data_storage.id

  # MISCONFIGURATION: Setting these to false allows public access to the bucket
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# VULNERABILITY 3: CRITICAL - Explicit Public Policy allowing anyone to delete/modify data
resource "aws_s3_bucket_policy" "wildcard_admin_access" {
  bucket = aws_s3_bucket.customer_data_storage.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowEveryoneFullControl"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "${aws_s3_bucket.customer_data_storage.arn}/*",
          aws_s3_bucket.customer_data_storage.arn
        ]
      }
    ]
  })
}

# TODO: Move this to a secure secret manager. 
# Exposed AI service key for automated data labeling:
variable "anthropic_key" {
  default = "sk-ant-api03-L69wa8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8-v2"
}
