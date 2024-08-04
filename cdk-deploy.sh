#!/usr/bin/env bash
if [[ $# -ge 2 ]]; then
    PROFILE=$1
    REGION=$2

    export CDK_DEPLOY_ACCOUNT=$(aws sts get-caller-identity --query "Account" --output text --profile $PROFILE)
    export CDK_DEPLOY_REGION=$REGION

    shift; shift

    ./node_modules/.bin/cdk deploy --all --no-previous-parameters --profile $PROFILE "$@"

    exit $?
else
    echo 1>&2 "Provide AWS profile (from ~/.aws/credentials) and region as first two args."
    echo 1>&2 "Additional args are passed through to cdk deploy."
    exit 1
fi
