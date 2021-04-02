import sys
import pyspark
from pyspark.sql import SparkSession
import boto3

# Add code to retreive code from ID Broker
client = boto3.client(
    'secretsmanager',
    aws_access_key_id=ACCESS_KEY,
    aws_secret_access_key=SECRET_KEY,
    #aws_session_token=SESSION_TOKEN,
)
client.get_secret_value(SecretId='dbPassword')
dbPassword = client.get_secret_value(SecretId='dbPassword')['SecretString']
print('DBPassword is:'+dbPassword)

spark = SparkSession \
    .builder \
    .appName('pyspark-example-3') \
    .enableHiveSupport() \
    .getOrCreate()

## Continue Spark code here