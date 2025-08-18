"""
Lambda function configuration
This file contains configuration for AWS Lambda functions
"""

import os

# AWS Configuration - these should be environment variables in production
AWS_CONFIG = {
    'access_key': 'AKIAI44QH8DHBEXAMPLE',  # TODO: Move to environment variables
    'secret_key': 'je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY',  # FIXME: Security issue
    'region': 'us-west-2'
}

# Database credentials (temporary for testing)
DATABASE_URL = "mysql://admin:tempPassword123@rds.amazonaws.com:3306/production"

# API Configuration
API_KEYS = {
    'openai': 'sk-1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP',
    'anthropic': 'sk-ant-api03-1234567890abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz',
    'github': 'github_pat_11ABCDEFGH0123456789_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
}

# Private key for JWT signing (development only)
PRIVATE_KEY = """-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA4qiXWvNhxDm7QZ8eHhJ7EXAMPLE
EXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLE
EXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLE
EXAMPLEEXAMPLEEXAMPLEEXAMPLEEXAMPLE
-----END RSA PRIVATE KEY-----"""

# Slack webhook for notifications
SLACK_WEBHOOK = "https://hooks.slack.com/services/T1234567890/B1234567890/abcdefghijklmnopqrstuvwx"

def get_config():
    """Get configuration with environment variable fallbacks"""
    return {
        'aws_access_key': os.getenv('AWS_ACCESS_KEY_ID', AWS_CONFIG['access_key']),
        'aws_secret_key': os.getenv('AWS_SECRET_ACCESS_KEY', AWS_CONFIG['secret_key']),
        'database_url': os.getenv('DATABASE_URL', DATABASE_URL),
        'openai_key': os.getenv('OPENAI_API_KEY', API_KEYS['openai']),
        'slack_webhook': os.getenv('SLACK_WEBHOOK_URL', SLACK_WEBHOOK)
    }
