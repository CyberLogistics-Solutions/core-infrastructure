# --- CLOUD INFRASTRUCTURE & STORAGE ---

# VULNERABILITY 1: Public access enabled via resource definition
resource "aws_s3_bucket" "customer_data_storage" {
  bucket = "cyber-logistics-customer-data-001"
}

resource "aws_s3_bucket_public_access_block" "insecure_config" {
  bucket = aws_s3_bucket.customer_data_storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# VULNERABILITY 2: CRITICAL - Explicit Public Policy allowing wildcard access
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

# VULNERABILITY 3: CRITICAL - Hardcoded AWS Provider Credentials (LEAK)
# This is a representative leak to trigger P0/Critical alerts
variable "aws_leak_example" {
  default = "AKIAEXAMPLE123456789" # Simulated Access Key
}

variable "aws_secret_leak_example" {
  default = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" # Simulated Secret Key
}
