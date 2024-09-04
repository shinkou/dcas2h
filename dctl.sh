#!/bin/bash
function help()
{
	cmd="$(basename $0)"
	cat <<EOF
Usage: $cmd [ OP [ OP [ OP ... ] ] ]

where OP can be:
  buildall      build all Docker images
  delall        delete previously created images and persistent volumes
  delimgs       delete previously created images
  delpvs        delete previously created persistent volumes
  upall         bring up all services
  downall       bring down all services
  help          print this usage and exit
EOF
}

function buildall()
{
	for service in init_hadoop hms zk sts init_hive init_airflow; do
		$DKRCMP build \
			--build-arg HADOOP_CONF_DIR=/etc/hadoop/conf \
			--build-arg SPARK_CONF_DIR=/etc/spark/conf \
			--build-arg HIVE_CONF_DIR=/etc/hive/conf \
			$service
	done
}

function delall()
{
	delpvs
	delimgs
}

function delimgs()
{
	for component in hadoop hive zookeeper spark apps airflow; do
		docker rmi -f dcas2h-$component
	done
}

function delpvs()
{
	for suffix in hdfs localstack pgdata redis scheduler webserver; do
		docker volume rm dcas2h_pv-$suffix
	done
}

function downall()
{
	$DKRCMP --profile init down
}

function upall()
{
	$DKRCMP up init_hadoop \
	&& $DKRCMP --profile init_hadoop down \
	&& $DKRCMP --profile init up -d
}

function main()
{
	for arg in "$@"; do
		case $arg in
			buildall|delall|delimgs|delpvs|upall|downall|help)
				${arg}
				;;
			*)
				$DKRCMP "$@"
				break
				;;
		esac
	done
}

docker compose version > /dev/null 2>&1
if [ 0 -eq $? ]; then
	DKRCMP="docker compose"
else
	docker-compose version > /dev/null 2>&1
	if [ 0 -eq $? ]; then
		DKRCMP=docker-compose
	else
		echo 'No docker compose found. Please install it to continue.'
		exit 1
	fi
fi

set -e

main "$@"
