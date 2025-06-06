#!/bin/bash
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Default values
DEFAULT_REGION="us-east-1"
DEFAULT_BUCKET_PREFIX="terraform-state"
DEFAULT_TABLE_PREFIX="terraform-locks"
RANDOM_SUFFIX=$((${RANDOM:0:4} * ${RANDOM:0:4}))

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  --bucket-name)
    BUCKET_NAME="$2"
    shift 2
    ;;
  --table-name)
    TABLE_NAME="$2"
    shift 2
    ;;
  --region)
    AWS_REGION="$2"
    shift 2
    ;;
  --help)
    echo "Usage: $0 [--bucket-name <bucket-name>] [--table-name <table-name>] [--region <aws-region>]"
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    echo "Usage: $0 [--bucket-name <bucket-name>] [--table-name <table-name>] [--region <aws-region>]"
    exit 1
    ;;
  esac
done

# Check required parameters
if [ -z "$BUCKET_NAME" ]; then
  BUCKET_NAME="${DEFAULT_BUCKET_PREFIX}-${random_number}-${RANDOM_SUFFIX}"
  echo -e "${YELLOW}No bucket name provided, using: ${BUCKET_NAME}${NC}"
fi

if [ -z "$TABLE_NAME" ]; then
  TABLE_NAME="${DEFAULT_TABLE_PREFIX}-${RANDOM_SUFFIX}"
  echo -e "${YELLOW}No table name provided, using: ${TABLE_NAME}${NC}"
fi

# Set default region if not provided
AWS_REGION=${AWS_REGION:-$DEFAULT_REGION}

echo -e "${YELLOW}=== Setting up Terraform Backend ===${NC}"
echo -e "${GREEN}AWS Region:${NC} $AWS_REGION"
echo -e "${GREEN}S3 Bucket:${NC} $BUCKET_NAME"
echo -e "${GREEN}DynamoDB Table:${NC} $TABLE_NAME"

# Check if AWS CLI is installed
if ! command -v aws &>/dev/null; then
  echo -e "${RED}Error: AWS CLI is not installed. Please install it first.${NC}"
  exit 1
fi

# Check AWS credentials
echo -e "${YELLOW}Checking AWS credentials...${NC}"
if ! aws sts get-caller-identity &>/dev/null; then
  echo -e "${RED}Error: AWS credentials not configured. Please run 'aws configure' first.${NC}"
  exit 1
fi

# Create S3 bucket
echo -e "${YELLOW}Creating S3 bucket...${NC}"
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo -e "${YELLOW}Bucket $BUCKET_NAME already exists${NC}"
else
  if [ "$AWS_REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION"
  else
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$AWS_REGION" --create-bucket-configuration LocationConstraint="$AWS_REGION"
  fi
  echo -e "${GREEN}✓ S3 bucket created${NC}"
fi

# Enable versioning on the S3 bucket
echo -e "${YELLOW}Enabling versioning on S3 bucket...${NC}"
aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled
echo -e "${GREEN}✓ Bucket versioning enabled${NC}"

# Enable server-side encryption
echo -e "${YELLOW}Enabling default encryption on S3 bucket...${NC}"
aws s3api put-bucket-encryption --bucket "$BUCKET_NAME" --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'
echo -e "${GREEN}✓ Bucket encryption enabled${NC}"

# Block public access
echo -e "${YELLOW}Blocking public access to S3 bucket...${NC}"
aws s3api put-public-access-block --bucket "$BUCKET_NAME" --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
echo -e "${GREEN}✓ Public access blocked${NC}"

# Create DynamoDB table
echo -e "${YELLOW}Creating DynamoDB table...${NC}"
if aws dynamodb describe-table --table-name "$TABLE_NAME" --region "$AWS_REGION" &>/dev/null; then
  echo -e "${YELLOW}DynamoDB table $TABLE_NAME already exists${NC}"
else
  aws dynamodb create-table \
    --table-name "$TABLE_NAME" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$AWS_REGION"
  echo -e "${GREEN}✓ DynamoDB table created${NC}"
fi

echo -e "${YELLOW}=== Terraform Backend Setup Complete ===${NC}"
echo -e "${GREEN}Add the following to your Terraform configuration:${NC}"
echo
echo -e "terraform {"
echo -e "  backend \"s3\" {"
echo -e "    bucket         = \"$BUCKET_NAME\""
echo -e "    key            = \"terraform.tfstate\""
echo -e "    region         = \"$AWS_REGION\""
echo -e "    dynamodb_table = \"$TABLE_NAME\""
echo -e "    encrypt        = true"
echo -e "  }"
echo -e "}"

# Update all GitHub workflow files with the backend configuration
WORKFLOWS_DIR=".github/workflows"
if [ -d "$WORKFLOWS_DIR" ]; then
  echo -e "${YELLOW}Updating GitHub workflow files with backend configuration...${NC}"
  
  # Process all YAML files in the workflows directory
  for WORKFLOW_FILE in "$WORKFLOWS_DIR"/*.yml "$WORKFLOWS_DIR"/*.yaml; do
    # Skip if no files match the pattern
    [ -e "$WORKFLOW_FILE" ] || continue
    
    echo -e "${YELLOW}Processing: $WORKFLOW_FILE${NC}"
    
    # Create a temporary file
    TMP_FILE=$(mktemp)
    
    # Replace the environment variables in the workflow file
    sed -e "s|TF_STATE_BUCKET:|TF_STATE_BUCKET: $BUCKET_NAME|" \
        -e "s|TF_STATE_KEY:|TF_STATE_KEY: terraform.tfstate|" \
        -e "s|TF_LOCK_TABLE:|TF_LOCK_TABLE: $TABLE_NAME|" \
        "$WORKFLOW_FILE" > "$TMP_FILE"
    
    # Replace the original file
    mv "$TMP_FILE" "$WORKFLOW_FILE"
  done
  
  echo -e "${GREEN}✓ GitHub workflow files updated${NC}"
fi
