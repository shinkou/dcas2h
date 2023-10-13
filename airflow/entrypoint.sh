#!/bin/bash
set -e

for arg in "$@"; do
	case $arg in
		scheduler)
			export CLASSPATH=$($HADOOP_HOME/bin/hdfs classpath --glob)
			if [ ! -d /tmp/spark/log ]; then
				mkdir -p /tmp/spark/log
			fi
			;;
	esac
done

"$@"
