#!/usr/bin/env bash
PROFILE=${1:-""}
REGION=${2:-"us-east-1"}

ACCCOUNT_ALIAS=$(aws iam list-account-aliases --profile sso-administrator@$PROFILE --region $REGION --query 'AccountAliases[0]' | tr -d '"')
ACCOUNT_ID=$(aws sts get-caller-identity --profile sso-administrator@$PROFILE --region $REGION --query "Account" | tr -d '"')
echo "Account Alias for $ACCOUNT_ID is $ACCCOUNT_ALIAS"
export CDK_DEPLOY_ACCOUNT=$ACCOUNT_ID
export CDK_DEPLOY_REGION=$REGION

echo "Emptying the cdk.out directory"
rm -rf ./cdk.out

./cdk-deploy.sh \
  sso-administrator@$PROFILE $REGION \
  --context "githubTokenSsmParameterName=" \
  --context "owner=pejulian" \
  --context "repo="
