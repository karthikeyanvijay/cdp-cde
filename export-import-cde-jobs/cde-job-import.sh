#!/bin/bash
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <parameter-file>"
    exit 1
fi
source $1
#### Import to Target service
#### Get token
export TARGET_TOKEN=`curl --user ${username}  -k https://$TARGET_SVC/gateway/authtkn/knoxtoken/api/v1/token | jq -r .access_token`
#### Import jobs
curl -k -H "Authorization: Bearer ${TARGET_TOKEN}" -X POST "https://$TARGET_VC/dex/api/v1/admin/import" -H "accept: application/json" -H "Content-Type: multipart/form-data" -F "file=@./${BACKUP_FILE_NAME};type=application/zip" -F duplicatehandling=error
