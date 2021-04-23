# Spark jobs dependent on "Pure" python packages

- Create a resource of type `python-env` and upload the `requirements.txt` file.
```
# Create resource of type python-env 
cde resource create --name custom_env_py3 --type python-env
 
# Upload the requirements.txt file to the resource
cde resource upload --name custom_env_py3 \
		--local-path requirements.txt
```
- Create & Run the job
```
# Create job 
cde job create --type spark \
	--application-file pyspark-example-3.py \
	--python-env-resource-name custom_env_py3 \
	--name pyspark-example-3 \
	--log-level INFO

# Run the job
cde job run --name pyspark-example-3
```