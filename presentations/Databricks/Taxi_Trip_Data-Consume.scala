// Databricks notebook source
// MAGIC %md
// MAGIC Based on demo at https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-kafka-spark-structured-streaming

// COMMAND ----------

// MAGIC %md 
// MAGIC ## Consuming All Data from Kafka

// COMMAND ----------

// The Kafka broker hosts and topic used to write to Kafka
// Edit both lines to match values from environment and in Producer notebook
val kafkaBrokers="10.0.0.4:9092,10.0.0.19:9092,10.0.0.20:9092"
val kafkaTopic="taxidata"

println("Finished setting Kafka broker and topic configuration.")

// COMMAND ----------

// Import libraries used for declaring schemas and working with JSON data
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._


// Define a schema for the data
val schema = (new StructType).add("dropoff_latitude", StringType).add("dropoff_longitude", StringType).add("extra", StringType).add("fare_amount", StringType).add("improvement_surcharge", StringType).add("lpep_dropoff_datetime", StringType).add("lpep_pickup_datetime", StringType).add("mta_tax", StringType).add("passenger_count", StringType).add("payment_type", StringType).add("pickup_latitude", StringType).add("pickup_longitude", StringType).add("ratecodeid", StringType).add("store_and_fwd_flag", StringType).add("tip_amount", StringType).add("tolls_amount", StringType).add("total_amount", StringType).add("trip_distance", StringType).add("trip_type", StringType).add("vendorid", StringType)
// Reproduced here for readability
//val schema = (new StructType)
//   .add("dropoff_latitude", StringType)
//   .add("dropoff_longitude", StringType)
//   .add("extra", StringType)
//   .add("fare_amount", StringType)
//   .add("improvement_surcharge", StringType)
//   .add("lpep_dropoff_datetime", StringType)
//   .add("lpep_pickup_datetime", StringType)
//   .add("mta_tax", StringType)
//   .add("passenger_count", StringType)
//   .add("payment_type", StringType)
//   .add("pickup_latitude", StringType)
//   .add("pickup_longitude", StringType)
//   .add("ratecodeid", StringType)
//   .add("store_and_fwd_flag", StringType)
//   .add("tip_amount", StringType)
//   .add("tolls_amount", StringType)
//   .add("total_amount", StringType)
//   .add("trip_distance", StringType)
//   .add("trip_type", StringType)
//   .add("vendorid", StringType)

println("Schema declared")


// COMMAND ----------

// Read a batch from Kafka for one-time write
val kafkaDF = spark.read.format("kafka").option("kafka.bootstrap.servers", kafkaBrokers).option("subscribe", kafkaTopic).option("startingOffsets", "earliest").load()

// Select data and write to file
val query = kafkaDF.select(from_json(col("value").cast("string"), schema) as "trip").write.format("parquet").option("path","/example/batchtaxidata").option("checkpointLocation", "/batchtaxicheckpoint").save()

println("Wrote data to file")

// COMMAND ----------

// MAGIC %md
// MAGIC This displays all of the files located in the directory used to house the consumed data
// MAGIC 
// MAGIC %fs ls "/example/batchtaxidata"

// COMMAND ----------

// MAGIC %fs ls "/example/batchtaxidata"

// COMMAND ----------

// Read the parquet data frames from dbfs to view the trip value stored in dataframe
val data = sqlContext.read.parquet("/example/batchtaxidata")

display(data)

// COMMAND ----------

// MAGIC %md 
// MAGIC ## Consuming select Data from Kafka
// MAGIC Initiate Clear State & Results before running

// COMMAND ----------

// The Kafka broker hosts and topic used to write to Kafka
// Edit both lines to match values from environment and in Producer notebook
val kafkaBrokers="10.0.0.4:9092,10.0.0.19:9092,10.0.0.20:9092"
val kafkaTopic="taxidata"

println("Finished setting Kafka broker and topic configuration.")

// COMMAND ----------

// Import bits useed for declaring schemas and working with JSON data
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._


// Define a schema for the data
// Modified schema to include limited pieces of data
val schema = (new StructType).add("passenger_count", StringType).add("payment_type", StringType).add("total_amount", StringType).add("trip_distance", StringType).add("trip_type", StringType).add("vendorid", StringType)

// Reproduced here for readability
//val schema = (new StructType)
//   .add("passenger_count", StringType)
//   .add("payment_type", StringType)
//   .add("total_amount", StringType)
//   .add("trip_distance", StringType)
//   .add("trip_type", StringType)
//   .add("vendorid", StringType)

println("Schema declared")

// COMMAND ----------

// Stream from Kafka
val kafkaStreamDF = spark.readStream.format("kafka").option("kafka.bootstrap.servers", kafkaBrokers).option("subscribe", kafkaTopic).option("startingOffsets", "earliest").load()

// Select data from the stream and write to file
kafkaStreamDF.select(from_json(col("value").cast("string"), schema) as "trip").writeStream.format("parquet").option("path","/example/streamingtaxidata").option("checkpointLocation", "/streamtaxicheckpoint").start.awaitTermination(30000)
println("Wrote data to file")

// COMMAND ----------

// MAGIC %fs ls "/example/streamingtaxidata"

// COMMAND ----------

val data = sqlContext.read.parquet("/example/streamingtaxidata")

display(data)
