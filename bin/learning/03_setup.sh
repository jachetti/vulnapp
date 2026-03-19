#!/bin/bash
# Setup Script for Scenario 3: Data Theft & Exfiltration
# Plants fake credentials and sensitive data

set -e

echo "[SETUP] Preparing Data Theft scenario..."

# Create fake credentials directory
mkdir -p /tmp/.app_secrets

# Plant AWS credentials with flag embedded
cat > /tmp/.app_secrets/aws_credentials << 'EOF'
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
region = us-east-1

# INTERNAL NOTE: FLAG{credentials_stolen_data_staged_for_exfiltration}
EOF

# Plant fake database config
cat > /tmp/.app_secrets/database.env << 'EOF'
DB_HOST=prod-db.internal.company.com
DB_USER=admin
DB_PASSWORD=SuperSecret123!
DB_NAME=customer_data
# Contains 1.2M customer records
EOF

# Plant fake Kubernetes service account token
mkdir -p /var/run/secrets/kubernetes.io/serviceaccount
echo "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRFRkFVTFQifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OnByb2Q6YXBwLXNhIiwiYXVkIjpbImFwaSJdLCJleHAiOjE5OTk5OTk5OTl9.SIGNATURE_FLAG_INSIDE" > /var/run/secrets/kubernetes.io/serviceaccount/token

# Plant fake API keys
cat > /tmp/.app_secrets/api_keys.json << 'EOF'
{
  "stripe_key": "sk_live_51HqhK2LoremIpsum",
  "sendgrid_key": "SG.LoremIpsumDolorSitAmet",
  "datadog_api_key": "1234567890abcdef1234567890abcdef"
}
EOF

chmod 600 /tmp/.app_secrets/*

echo "[SETUP] ✓ Planted fake credentials and sensitive data"
echo "[SETUP] ✓ Flag hidden in AWS credentials file"
echo "[SETUP] ✓ Attacker must find and exfiltrate data"
echo "[SETUP] Ready for exploitation!"
