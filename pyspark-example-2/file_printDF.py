from pyspark.sql import SparkSession, DataFrame

def fn_printDF(csvDF):
    print('Print inside fn_printDF')
    csvDF.show()
