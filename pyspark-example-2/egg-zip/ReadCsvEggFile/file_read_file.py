from pyspark.sql import SparkSession, DataFrame

spark = SparkSession.builder \
            .enableHiveSupport() \
            .getOrCreate()

def fn_read_file(path):
    df = spark.read.format('csv') \
            .option('header', 'true') \
            .option('inferSchema', 'true') \
            .load(path)
    return df
