# Module Demo Streaming HDInsight Kafka Data into Azure Databricks
This document includes the code from the demo as well as include links for references to demo steps. 

General Reference for notebook code: https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-kafka-spark-structured-streaming

Apache Kafka at Azuredatabricks.net: https://docs.azuredatabricks.net/spark/latest/structured-streaming/kafka.html

## Pre-Requisites
Azure Subscription
Exercise files for course downloaded from (pluralsight.com)
CLI requirements
- Databricks CLI: https://docs.databricks.com/user-guide/dev-tools/databricks-cli.html#set-up-the-cli
- Python

## Demo Building a Kafka cluster with Azure HDInsight
Reference URL: https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-get-started

## Demo - Configure Kafka to advertise IP addresses 
Reference URL: https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-connect-vpn-gateway#configure-kafka-for-ip-advertising

Code block for kafka-env:

    IP_ADDRESS=$(hostname -i)
    echo advertised.listeners=$IP_ADDRESS
    sed -i.bak -e '/advertised/{/advertised@/!d;}' /usr/hdp/current/kafka-broker/conf/server.properties
    echo "advertised.listeners=PLAINTEXT://$IP_ADDRESS:9092" >> /usr/hdp/current/kafka-broker/conf/server.properties



## Demo: Create a Kafka topic in HDInsight
Reference URL: https://docs.microsoft.com/en-us/azure/hdinsight/kafka/apache-kafka-quickstart-resource-manager-template#manage-apache-kafka-topics

>ssh sshuser@<your-hdinsight-clustername>-ssh.azurehdinsight.net
. You can paste with paste (ctrl+shift+v)

At the prompt, enter the following commands to create the topic.
> export TOPIC="taxidata"
> export ZOOKEEPERS="your comma separated zookeeper servers"
> export ZOOKEEPERS="10.0.0.16,10.0.0.19,10.0.0.20"
Create Topic code:
> /usr/hdp/current/kafka-broker/bin/kafka-topics.sh --create --replication-factor 3 --partitions 4 --topic $TOPIC --zookeeper $ZOOKEEPERS

List Topics
> /usr/hdp/current/kafka-broker/bin/kafka-topics.sh --list --zookeeper $KAFKAZOOKEEPERS

## demo Set up a Spark cluster using Azure Databricks
Reference URL: https://docs.microsoft.com/en-us/azure/azure-databricks/quickstart-create-databricks-workspace-portal


## Demo Peer the virtual networks
Reference URL: https://docs.microsoft.com/en-us/azure/azure-databricks/quickstart-create-databricks-workspace-portal


## Demo - Producing and Consuming Events in Azure Databricks
Import Notebooks from exercise files 
./taxi_trip_data-consume.scala
./taxi_trip_data-produce.scala