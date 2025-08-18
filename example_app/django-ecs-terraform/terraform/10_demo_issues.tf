# Test Terraform configuration for security scanning demo
# This file intentionally contains security misconfigurations for testing

resource "aws_security_group" "demo_sg" {
  name_prefix = "demo-sg"
  description = "Demo security group with intentional issues"
  
  # Security Issue: Overly permissive ingress rule
  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Should be restricted
  }
  
  # Security Issue: Overly permissive egress rule  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Should be restricted
  }
}

# Security Issue: S3 bucket without encryption
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "my-demo-bucket-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Security Issue: RDS instance with weak configuration
resource "aws_db_instance" "demo_db" {
  identifier     = "demo-database"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  # These would typically come from variables or secrets manager
  username = "admin"
  password = var.db_password
  
  # Security Issues:
  storage_encrypted        = false  # Should be true
  publicly_accessible     = true   # Should be false for most cases
  backup_retention_period = 0      # Should be > 0
  skip_final_snapshot     = true   # Should be false
}

# Example of how secrets might accidentally end up in code
locals {
  # This is just a demo - never hardcode real credentials!
  database_url = "mysql://demo_user:demo_pass_123@localhost:3306/demo_db"
  
  # API configuration that might contain sensitive data
  config = {
    api_endpoint = "https://api.example.com"
    api_key      = "demo_key_abc123xyz789"  # Should use variables
  }
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = "change_me_in_production"  # This should not have a default
}
