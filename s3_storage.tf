# --- CLOUD INFRASTRUCTURE & STORAGE ---

# VULNERABILITY 1: Public access enabled via resource definition
resource "aws_s3_bucket" "customer_data_storage" {
  bucket = "cyber-logistics-customer-data-001"
}

resource "aws_s3_bucket_public_access_block" "insecure_config" {
  bucket = aws_s3_bucket.customer_data_storage.id

  # MISCONFIGURATION: Allows public access to the bucket
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

# --- COMPUTE & SECRETS ---

# VULNERABILITY 3: CRITICAL - Hardcoded AWS Credentials in User Data
resource "aws_instance" "production_web_server" {
  ami           = "ami-0c55b1adcbfafe1e0" 
  instance_type = "t2.micro"

  # DANGEROUS: Secrets leaked in metadata/logs
  user_data = <<-EOF
              #!/bin/bash
              export AWS_ACCESS_KEY_ID="AKIAEXAMPLE123456789"
              export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
              export DB_PASSWORD="super_secret_production_password_99"
              EOF

  tags = {
    Name = "Web-Server-Prod"
  }
}

# --- IDENTITY & ACCESS MANAGEMENT (IAM) ---

# VULNERABILITY 4: CRITICAL - Over-privileged Admin Role assigned to a resource
resource "aws_iam_role" "excessive_admin_role" {
  name = "web-server-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attach" {
  role       = aws_iam_role.excessive_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# --- APPLICATION SECRETS ---

# VULNERABILITY 5: Exposed AI service key (Anthropic)
variable "anthropic_key" {
  description = "AI service key for automated data labeling"
  default     = "sk-ant-api03-L69wa8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8p8-v2"
}
