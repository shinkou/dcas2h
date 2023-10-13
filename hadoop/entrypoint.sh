#!/bin/bash
if [ 0 -eq $# ]; then
	service ssh start
	hdfs --daemon start --config $HADOOP_CONF_DIR namenode
	hdfs --daemon start --config $HADOOP_CONF_DIR datanode
	hdfs --daemon start --config $HADOOP_CONF_DIR secondarynamenode
	hdfs --daemon start --config $HADOOP_CONF_DIR httpfs
	yarn --daemon start --config $HADOOP_CONF_DIR nodemanager
	yarn --daemon start --config $HADOOP_CONF_DIR resourcemanager
	tail -f /var/log/lastlog
else
	"$@"
fi
