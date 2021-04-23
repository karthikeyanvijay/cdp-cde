# PySpark with custom Python dependencies

## Option to include dependencies in each job

```
cde spark submit pyspark-example-2a.py \
	--py-file file_printDF.py \
	--py-file egg-zip/ReadCsvEggFile-1.0-py3.7.egg \
	--py-file egg-zip/printPath.zip \
	--driver-cores 1 --driver-memory 1g \
	--executor-cores 1 --executor-memory 1g --num-executors 1 \
	--job-name pyspark-example-2a \
	--log-level INFO \
	--hide-logs
```

## Create a resource & attach it to jobs
- Commnads to create a resource for the application file & dependent files
```
# Create a resource for the application file
cde resource create --type files --name pyspark-example-2b-resource
cde resource upload --name pyspark-example-2b-resource \
	--local-path pyspark-example-2b.py

# Create a resource for the common dependencies
cde resource create --type files --name common-py-files
cde resource upload --name common-py-files \
	--local-path file_printDF.py \
	--local-path egg-zip/ReadCsvEggFile-1.0-py3.7.egg \
	--local-path egg-zip/printPath.zip
```
- Create a job with the resources
```
# Create the CDE job
cde job create --type spark \
	--application-file pyspark-example-2b.py \
	--driver-cores 1 --driver-memory 1g \
	--executor-cores 1 --executor-memory 1g --num-executors 1 \
	--mount-1-resource pyspark-example-2b-resource  \
	--mount-2-prefix "commonPyFiles/" \
	--mount-2-resource common-py-files  \
	--name pyspark-example-2b \
	--log-level INFO

# Run the job
cde job run --name pyspark-example-2b
```