#!/bin/bash

# Set variables
REPO_NAME="codeco_app"
AWS_REGION="eu-west-2"

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
    echo "❌ AWS CLI is not installed. Please install it first." >&2
    exit 1
fi

# Check if repository already exists
EXISTING_REPO=$(aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$AWS_REGION" 2>/dev/null)

if [[ -n "$EXISTING_REPO" ]]; then
    echo "✅ Repository '$REPO_NAME' already exists in region '$AWS_REGION'. No action needed."
else
    # Create the repository
    echo "🚀 Creating ECR repository: $REPO_NAME in region $AWS_REGION..."
    aws ecr create-repository \
        --repository-name "$REPO_NAME" \
        --image-scanning-configuration scanOnPush=true \
        --encryption-configuration encryptionType=AES256 \
        --region "$AWS_REGION"

    if [[ $? -eq 0 ]]; then
        echo "✅ Successfully created repository: $REPO_NAME"
    else
        echo "❌ Failed to create repository: $REPO_NAME" >&2
        exit 1
    fi
fi

# Output repository URL
REPO_URI=$(aws ecr describe-repositories --repository-names "$REPO_NAME" --region "$AWS_REGION" --query 'repositories[0].repositoryUri' --output text)
echo "🔗 Repository URI: $REPO_URI"

exit 0
