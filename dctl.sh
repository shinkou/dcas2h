#!/bin/bash
function help()
{
	cmd="$(basename $0)"
	cat <<EOF
Usage: $cmd [ OP [ OP [ OP ... ] ] ]

where OP can be:
  buildall      build all Docker images
  delall        delete previously built images
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
	for component in hadoop hive zookeeper spark apps airflow; do
		docker rmi -f dcas2h-$component
	done
}

function upall()
{
	$DKRCMP up init_hadoop \
	&& $DKRCMP --profile init_hadoop down \
	&& $DKRCMP --profile init up -d
}

function downall()
{
	$DKRCMP --profile init down
}

function main()
{
	export AWS_ACCESS_KEY_ID=blah
	export AWS_SECRET_ACCESS_KEY=meh
	export AWS_DEFAULT_REGION=us-east-1

	for arg in "$@"; do
		case $arg in
			buildall|delall|upall|downall|help)
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
	echo 'docker compose v2 found.'
	DKRCMP="docker compose"
else
	docker-compose version > /dev/null 2>&1
	if [ 0 -eq $? ]; then
		echo 'docker compose v1 found.'
		DKRCMP=docker-compose
	else
		echo 'No docker compose found. Please install it to continue.'
		exit 1
	fi
fi

set -e

main "$@"
