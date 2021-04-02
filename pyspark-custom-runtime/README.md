# Custom Runtime container for CDE
This document contain steps to build a custom container for CDE with all the required dependencies.

## Steps to build the custom container for CDE
#### Get the base image details
- Login to the Cloudera Docker Repo - `docker login https://container.repository.cloudera.com -u $CLDR_REPO_USER -p $CLDR_REPO_PASS`

- Check the Available catalogs - `curl -u $CLDR_REPO_USER:$CLDR_REPO_PASS -X GET https://container.repository.cloudera.com/v2/_catalog`
- Check the images list & select an image - `curl -u $CLDR_REPO_USER:$CLDR_REPO_PASS -X GET https://container.repository.cloudera.com/v2/cloudera/dex/dex-spark-runtime-2.4.5/tags/list`
- To experiment with the container to come up with the right docker file use [these](interactive-build/README.md) instructions.

#### Build & push docker file
Build & push the Docker image to the container repository
```
docker build --network=host -t vka3/cde:cde-runtime-ml . -f cde-runtime-ml.Dockerfile
docker push docker.io/vka3/cde:cde-runtime-ml
```

## Create a job using the custom container
#### Create a CDE resource
Create a CDE resource type `custom-runtime-image`. Sample command - 
```
cde resource create --type="custom-runtime-image" --image-engine="spark2" \
        --name="cde-runtime-ml"  --image="docker.io/vka3/cde:cde-runtime-ml"
```

#### Create the CDE job
Use the `runtime-image-resource-name` when creating the job. Sample command - 
```
cde job create --type spark --name ml-scoring-job \
        --runtime-image-resource-name cde-runtime-ml --application-file ./ml-scoring.py \
        --num-executors 3 --executor-memory 3G --driver-memory 3G
```