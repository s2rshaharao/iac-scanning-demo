# Test Secrets Detection

This file contains intentional test secrets to verify our secrets detection pipeline works correctly.

## Test AWS Credentials (FAKE - for testing only)

```bash
# These are fake credentials for testing TruffleHog
export AWS_ACCESS_KEY_ID="AKIAIOSFODNN7EXAMPLE"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

## Test Database Connection (FAKE)

```yaml
database:
  host: localhost
  username: admin
  password: "super_secret_password_123"
  api_key: "sk-1234567890abcdef1234567890abcdef12345678"
```

## Test GitHub Token (FAKE)

```
GITHUB_TOKEN=ghp_1234567890abcdef1234567890abcdef12345678
```

**Note**: These are intentionally fake secrets used to test our security scanning pipeline. Real secrets should never be committed to version control!
