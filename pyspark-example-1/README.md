# PySpark job with no additional dependencies

To run this example via CDP CLI, use the following command
```
# Using Spark Submit to submit an Ad-Hoc job
cde spark submit pyspark-example-1.py \
	--file read-acid-table.sql \
	--driver-cores 1 --driver-memory 1g \
	--executor-cores 1 --executor-memory 1g --num-executors 1 \
	--job-name pyspark-example-1 \
	--log-level INFO \
	--hide-logs
```