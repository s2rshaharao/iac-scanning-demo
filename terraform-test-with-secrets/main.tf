# Terraform Configuration with Secrets (TEST ONLY)

# WARNING: This file contains intentional test secrets for validating our security pipeline
# In real scenarios, these would be flagged and need to be removed!

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# FAKE AWS Provider Configuration - Contains hardcoded credentials (BAD!)
provider "aws" {
  region     = "us-west-2"
  access_key = "AKIAIOSFODNN7EXAMPLE"          # TruffleHog should catch this
  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"  # And this too
}

# Database instance with hardcoded password (BAD!)
resource "aws_db_instance" "example" {
  identifier     = "test-database"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  
  db_name  = "testdb"
  username = "admin"
  password = "MyS3cr3tP@ssw0rd!"  # TruffleHog should detect this
  
  allocated_storage = 20
  storage_type      = "gp2"
  
  # Security group with overly permissive access (Trivy should catch this)
  vpc_security_group_ids = [aws_security_group.database.id]
  
  skip_final_snapshot = true
  
  tags = {
    Name = "test-database"
    # Fake API key in tags (BAD!)
    APIKey = "sk-1234567890abcdef1234567890abcdef"
  }
}

# Security group that's too permissive (Trivy should flag this)
resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Database security group"
  
  # This is intentionally insecure for testing
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Trivy should flag this as too permissive
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# GitHub token in locals (BAD!)
locals {
  github_token = "ghp_1234567890abcdef1234567890abcdef12345678"  # Should be detected
  slack_webhook = "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX"
}

# Output that might expose sensitive data
output "database_endpoint" {
  value = aws_db_instance.example.endpoint
}

output "debug_info" {
  # This is bad practice - exposing sensitive info in outputs
  value = {
    password = "MyS3cr3tP@ssw0rd!"  # Another secret to catch
    api_key  = local.github_token
  }
  sensitive = false  # Should be true if containing secrets
}
