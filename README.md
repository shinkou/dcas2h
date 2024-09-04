# dcas2h

**dcas2h** is a docker-compose stack created to find out the compatibilities
and other issues among:

- Apache Airflow
- Apache Spark
- Apache Hive
- Apache Hadoop

## Setup

To build the necessary Docker images, use this script:

```
$ ./dctl.sh buildall
```

Once all images are built, issue this to bring up the containers:

```
$ ./dctl.sh upall
```

To stop all containers, run this:

```
$ ./dctl.sh downall
```

To restart the necessary containers with previously saved data, do:

```
$ ./dctl.sh up
```

To restart with clean databases without rebuilding any image, do:

```
$ ./dctl.sh delpvs upall
```

Please note that you can remove all Docker images and persistent volumes
created anytime with this:

```
$ ./dctl.sh delall
```

## Service Access

To access Airflow's web UI, simply point your web browser to
[http://localhost:8080][1].

Redis can be accessed by running the following command:

```
$ ./dctl.sh exec -- redis redis-cli
```

HiveServer2 is accessible via beeline like this:

```
$ ./dctl.sh exec scheduler beeline -u jdbc:hive2://hms:10000/
```

Similarly, for access to Spark-ThriftServer, simply do this:

```
$ ./dctl.sh exec scheduler beeline -u jdbc:hive2://sts:10000/
```

## Issue of spark-sql Execution

When sts is up and running, any spark-sql execution will wait (for
connection?) indefinitely. However, as soon as sts stops, any execution of
spark-sql which has been waiting will be able to resume and continue.

### Steps to Reproduce

Open a terminal and execute the followings:

```
$ ./dctl.sh buildall upall
```

It will take a while to finish.

When containers are up and you are returned to the command prompt, run:

```
$ ./dctl.sh exec scheduler spark-sql -e 'show databases'
```

The command will NEVER start actually running, until you do the next step.

Now open another terminal and execute the command below:

```
$ ./dctl.sh stop sts
```

Once the sts closes, the spark SQL command issued will run promptly.

---
[1]: http://localhost:8080
