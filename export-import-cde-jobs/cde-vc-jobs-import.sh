#!/bin/bash
# Sample Usage: cde-vc-jobs-import.sh <target-cluster-name> <target-vc-name> <workload-username> <file-name>
# Description: 
#   This script imports the jobs to the Virtual Cluster.
#   Script assumes that the CDE cli is already setup with the right access.
#   When prompted, user should enter their workload password
# Author: Vijay Anand Karthikeyan

if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <target-cluster-name> <target-vc-name> <workload-username> <file-name>"
    exit 1
fi

TARGET_CLUSTER_NAME=$1
TARGET_VC_NAME=$2
USERNAME=$3
FILE_NAME=$4

# Derive the required parameters from the input
TARGET_CLUSTER_ID=$(cdp de list-services | jq -r '.services[] | select( .name == '\"$TARGET_CLUSTER_NAME\"' and .status == "ClusterCreationCompleted") | .clusterId')
TARGET_VC_ID=$(cdp de list-vcs --cluster-id $TARGET_CLUSTER_ID | jq -r '.vcs[] | select( .vcName == '\"$TARGET_VC_NAME\"' and .clusterId == '\"$TARGET_CLUSTER_ID\"' and .status == "AppInstalled") | .vcId')
TARGET_VCAPIURL=$(cdp de describe-vc --cluster-id $TARGET_CLUSTER_ID --vc-id $TARGET_VC_ID | jq -r '.vc | select( .vcName == '\"$TARGET_VC_NAME\"' and .clusterId == '\"$TARGET_CLUSTER_ID\"' and .status == "AppInstalled") | .vcApiUrl')
TARGET_DOMAIN=$(echo $TARGET_VCAPIURL | awk -F[/:] '{print $4}' | awk -F. '{ for (i=2; i<=NF; i++) printf "."$i }')
TARGET_SERVICE="service"$TARGET_DOMAIN

echo "Target Cluster ID: $TARGET_CLUSTER_ID, Name: $TARGET_CLUSTER_NAME"
echo "Target VC      ID: $TARGET_VC_ID, Name: $TARGET_VC_NAME"
echo "Target VC API URL: $TARGET_VCAPIURL"
echo ""

# Get token
TARGET_TOKEN=$(curl -s --user ${USERNAME} -k https://$TARGET_SERVICE/gateway/authtkn/knoxtoken/api/v1/token | jq -r .access_token)

#### Import jobs
curl -k -H "Authorization: Bearer ${TARGET_TOKEN}" -X POST "$TARGET_VCAPIURL/admin/import" -H "accept: application/json" -H "Content-Type: multipart/form-data" -F "file=@./${FILE_NAME};type=application/zip" -F duplicatehandling=error
if [ $? -eq 0 ]; then
    echo "Jobs import to CDE service ${TARGET_CLUSTER_NAME}, virtual cluster ${TARGET_VC_NAME} succeeded"
else
    echo "Job import failed"
fi
