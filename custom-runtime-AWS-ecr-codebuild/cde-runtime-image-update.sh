#!/bin/bash
# Script to update Custom runtime resource using CDE CLI
# Run the API Command to backup the job configuration
# Author: Vijay Anand Karthikeyan

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FROM_IMAGE_RESOURCE_NAME> <TO_IMAGE_RESOURCE_NAME>"
    exit 1
fi

FROM_IMAGE_RESOURCE_NAME=cde-runtime-vijay-1
TO_IMAGE_RESOURCE_NAME=cde-runtime-pandas-vijay-2

echo "Updating all jobs with $FROM_IMAGE_RESOURCE_NAME to $TO_IMAGE_RESOURCE_NAME"
echo "Listing All jobs with $FROM_IMAGE_RESOURCE_NAME as runtime"
cde job list | jq -r ".[] | select(.runtimeImageResourceName != null) |  select(.runtimeImageResourceName == "$FROM_IMAGE_RESOURCE_NAME") | .name"

# Prompting for user configuration
echo "Do you wish to continue ?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) echo "Proceeding..."; break;;
        No ) exit 0;;
    esac
done

# Updating job information
for job_name in `cde job list | jq -r ".[] | select(.runtimeImageResourceName != null) |  select(.runtimeImageResourceName == \"$FROM_IMAGE_RESOURCE_NAME\") | .name"`
do
cde job update --name $job_name --runtime-image-resource-name $TO_IMAGE_RESOURCE_NAME
if [ $? -eq 0 ]; then
    echo "Job ${job_name}" updated successfully"
else
    echo "Job ${job_name}" update failed"
fi
done

