#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <parameter-file>"
    exit 1
fi
source $1
#### Get token
export SOURCE_TOKEN=`curl --user ${username}  -k https://$SOURCE_SVC/gateway/authtkn/knoxtoken/api/v1/token | jq -r .access_token`
echo ${SOURCE_TOKEN}
#### Export All Jobs
curl -H "Authorization: Bearer ${SOURCE_TOKEN}" -k -X GET "https://$SOURCE_VC/dex/api/v1/admin/export?exportjobs=true&exportjobresources=true&exportresources=false" -H "accept: application/zip" --output ${BACKUP_FILE_PREFIX}_source_export.zip
