#!/usr/bin/env bash
PROFILE=${1}
GITHUB_TOKEN_SSM_PARAMETER_NAME=${2}
REPO=${3}
OWNER=${4}
REGION=${5:-"us-east-1"}

if [ -z "${PROFILE}" ]; then
    echo "PROFILE not set"
    exit 1
fi

if [ -z "${GITHUB_TOKEN_SSM_PARAMETER_NAME}" ]; then
    echo "GITHUB_TOKEN_SSM_PARAMETER_NAME not set"
    exit 1
fi

if [ -z "${REPO}" ]; then
    echo "REPO not set"
    exit 1
fi

if [ -z "${OWNER}" ]; then
    echo "OWNER not set"
    exit 1
fi

ACCCOUNT_ALIAS=$(aws iam list-account-aliases --profile sso-administrator@$PROFILE --region $REGION --query 'AccountAliases[0]' | tr -d '"')
ACCOUNT_ID=$(aws sts get-caller-identity --profile sso-administrator@$PROFILE --region $REGION --query "Account" | tr -d '"')

echo "Account Alias for $ACCOUNT_ID is $ACCCOUNT_ALIAS"

export CDK_DEPLOY_ACCOUNT=$ACCOUNT_ID
export CDK_DEPLOY_REGION=$REGION

echo "Emptying the cdk.out directory"
rm -rf ./cdk.out

./cdk-deploy.sh \
  sso-administrator@$PROFILE $REGION \
  --context "githubTokenSsmParameterName=$GITHUB_TOKEN_SSM_PARAMETER_NAME" \
  --context "owner=$OWNER" \
  --context "repo=$REPO"
