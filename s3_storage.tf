# This Terraform file defines a storage bucket for customer data
# VULNERABILITY: Public access is enabled, making the bucket accessible to the entire internet.

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
