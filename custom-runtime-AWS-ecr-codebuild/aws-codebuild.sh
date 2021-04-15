#!/bin/bash
# Wrapper script to kick off automate AWS codebuild
# Author: Vijay Anand Karthikeyan

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <code-build-project-name>"
    exit 1
fi

zip cde-image-build.zip buildspec.yml Dockerfile
aws s3 cp cde-image-build.zip s3://vkarthikeyan-cdp/
rm cde-image-build.zip

check_project=`aws codebuild list-projects | jq -r '.projects | select("${1}") | .[]'`
if [ $1 == $check_project ]; then
  echo "${1} Project Exists"
  #aws codebuild delete-project --name cde-ml-xgboost-build
  aws codebuild update-project --cli-input-json file://aws-codebuild.json
else
  echo "Creating project"
  aws codebuild create-project --cli-input-json file://aws-codebuild.json
fi

# Start Build
aws codebuild start-build --project-name cde-ml-xgboost-build
