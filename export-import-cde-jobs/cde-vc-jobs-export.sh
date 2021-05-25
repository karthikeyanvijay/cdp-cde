#!/bin/bash
# Sample Usage: cde-vc-jobs-export.sh <source-cluster-name> <source-vc-name> <workload-username>
# Description: 
#   This script exports the jobs from the Virtual Cluster.
#   Script assumes that the CDE cli is already setup with the right access.
#   When prompted, user should enter their workload password
# Author: Vijay Anand Karthikeyan

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source-cluster-name> <source-vc-name> <workload-username>"
    exit 1
fi

SOURCE_CLUSTER_NAME=$1
SOURCE_VC_NAME=$2
USERNAME=$3
SOURCE_VC_EXPORT_FILE_NAME=${SOURCE_CLUSTER_NAME}-${SOURCE_VC_NAME}.zip

# Derive the required parameters from the input
SOURCE_CLUSTER_ID=$(cdp de list-services | jq -r '.services[] | select( .name == '\"$SOURCE_CLUSTER_NAME\"' and .status == "ClusterCreationCompleted") | .clusterId')
SOURCE_VC_ID=$(cdp de list-vcs --cluster-id $SOURCE_CLUSTER_ID | jq -r '.vcs[] | select( .vcName == '\"$SOURCE_VC_NAME\"' and .clusterId == '\"$SOURCE_CLUSTER_ID\"' and .status == "AppInstalled") | .vcId')
SOURCE_VCAPIURL=$(cdp de describe-vc --cluster-id $SOURCE_CLUSTER_ID --vc-id $SOURCE_VC_ID | jq -r '.vc | select( .vcName == '\"$SOURCE_VC_NAME\"' and .clusterId == '\"$SOURCE_CLUSTER_ID\"' and .status == "AppInstalled") | .vcApiUrl')
SOURCE_DOMAIN=$(echo $SOURCE_VCAPIURL | awk -F[/:] '{print $4}' | awk -F. '{ for (i=2; i<=NF; i++) printf "."$i }')
SOURCE_SERVICE="service"$SOURCE_DOMAIN

echo "Source Cluster ID: $SOURCE_CLUSTER_ID, Name: $SOURCE_CLUSTER_NAME"
echo "Source VC      ID: $SOURCE_VC_ID, Name: $SOURCE_VC_NAME"
echo "Source VC API URL: $SOURCE_VCAPIURL"
echo ""

# Get token
SOURCE_TOKEN=$(curl -s --user ${USERNAME} -k https://$SOURCE_SERVICE/gateway/authtkn/knoxtoken/api/v1/token | jq -r .access_token)

# Export jobs
curl -s -H "Authorization: Bearer ${SOURCE_TOKEN}" -k -X GET "$SOURCE_VCAPIURL/admin/export?exportjobs=true&exportjobresources=true&exportresources=false" -H "accept: application/zip" --output ${SOURCE_VC_EXPORT_FILE_NAME}
if [ $? -eq 0 ]; then
    echo "Jobs from the CDE service ${SOURCE_CLUSTER_NAME}, virtual cluster ${SOURCE_VC_NAME} exported to ${SOURCE_VC_EXPORT_FILE_NAME}"
else
    echo "Job export failed"
fi