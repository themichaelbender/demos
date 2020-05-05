// Databricks notebook source
// MAGIC %md
// MAGIC 
// MAGIC 
// MAGIC ## Importing data on New York City Taxi Trip Data
// MAGIC 
// MAGIC Based on from the New York City Taxi data REST API for 2016 Green Taxi Trip Data at https://data.cityofnewyork.us/Transportation/2016-Green-Taxi-Trip-Data/hvrh-b6nb

// COMMAND ----------

// MAGIC %md
// MAGIC Based on demo at https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-kafka-spark-structured-streaming

// COMMAND ----------

import spark.implicits._

// Load the data from the New York City Taxi data REST API for 2016 Green Taxi Trip Data
val url="https://data.cityofnewyork.us/resource/pqfs-mqru.json"
val result = scala.io.Source.fromURL(url).mkString

// Create a dataframe from the JSON data
val taxiDF = spark.read.json(Seq(result).toDS)

// Display the dataframe containing trip data
taxiDF.show()

// COMMAND ----------

// The Kafka broker hosts and topic used to write to Kafka
// Edit both lines to max values from environment
val kafkaBrokers="10.0.0.4:9092,10.0.0.19:9092,10.0.0.20:9092"
val kafkaTopic="taxidata"

println("Finished setting Kafka broker and topic configuration.")

// COMMAND ----------

// Select the vendorid as the key and save the JSON string as the value.
val query = taxiDF.selectExpr("CAST(vendorid AS STRING) as key", "to_JSON(struct(*)) AS value").write.format("kafka").option("kafka.bootstrap.servers", kafkaBrokers).option("topic", kafkaTopic).save()

println("Data sent to Kafka")
