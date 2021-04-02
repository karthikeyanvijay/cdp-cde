import sys
import os
import pyspark
from pyspark.sql import SparkSession

allFiles = [os.path.join(dp, f) for dp, dn, fn in os.walk(os.path.expanduser('/app/mount')) for f in fn]
print('All Files under /app/mount:')
print(allFiles)

# Add additional dependencies to sys path
mounthPath='/app/mount/commonPyFiles/'
sys.path.append(mounthPath) # Added mountpath to path since file_printDF.py is not in current path anymore
sys.path.append(mounthPath+'ReadCsvEggFile-1.0-py3.7.egg')
sys.path.append(mounthPath+'printPath.zip')

# Import the additional dependencies
from ReadCsvEggFile import file_read_file
from file_printDF import fn_printDF
from printPath import file_printPath

spark = SparkSession \
    .builder \
    .appName('pyspark-example-2b') \
    .enableHiveSupport() \
    .getOrCreate()

# Use the function in the ReadCsvEggFile
csvDF=file_read_file.fn_read_file('s3a://bucketname/path/test.csv')

# Use the function from file_printDF.py file
fn_printDF(csvDF)

# Use the function from printPath.zip file
file_printPath.fn_printPath()
