import pyspark
from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName('pyspark-example-1') \
    .enableHiveSupport() \
    .getOrCreate()

# List all databases
spark.sql('show databases').show(n=2)

# Read SQL from file & execute query
sql = open('/app/mount/read-acid-table.sql', 'r').read().replace('\n', ' ')
df = spark.sql(sql)
df.show(n=3)