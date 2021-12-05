# Spark client running into YARN cluster in Docker

Apache Hadoop YARN is a resource management and job scheduling technology in the open source Hadoop distributed processing framework.
This Docker image contains Hadoop binaries prebuilt and uploaded in Docker Hub.

## Shell Scripts Inside 

> run_hadoop.sh

Sets up the environment for the YARN cluster by executing the following steps :
- sets environment variables for HADOOP and YARN
- starts the SSH service and scans the slave nodes for passwordless SSH
- copies the Hadoop configuration files to slave nodes
- initializes the HDFS filesystem
- starts Hadoop Name node and Data nodes
- starts YARN Resource and Node managers

> create_conf_files.sh

Creates the following Hadoop files $HADOOP/etc/hadoop directory :
- core-site.xml
- hdfs-site.xml
- mapred-site.xml
- yarn-site.xml
- hadoop-env.sh

## Initial Steps on Docker Swarm

To start with, start Swarm mode in Docker in node1
```shell
$ docker swarm init
Swarm initialized: current node (xv7mhbt8ncn6i9iwhy8ysemik) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token <token> <IP node1>:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Add more workers in two or more hosts (node2, node3, ...) by joining them to manager running the following command in each node.
```shell
$ docker swarm join --token <token> <IP node1>:2377
```

Change the workers as managers in node2, node3, ... running the following in node1.
```shell
$ docker node promote node2
$ docker node promote node3
$ docker node promote ...
```

Start the YARN cluster by creating a Docker stack 
```shell
$ docker stack deploy -c docker-compose.yml yarn
```

## Set up steps on Docker Containers

Identify which Docker container started as Hadoop master and run the following docker exec command
```shell
$ docker container ls   # run it in each node and check which <container ID> is running the Hadoop master constainer
$ docker container exec -it <container ID> bash
```

Inside the Hadoop master container, get the public SSH key
```shell
$ cat .ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABg...
...QwJ3enC7dGplWvNvQeoMSiOGuMo0= root@8c331d607356
```

Identify which Docker container started as Spark client and run the following docker exec command
```shell
$ docker container ls   # run it in each node and check which <container ID> is running the Spark client constainer
$ docker container exec -it <container ID> bash
```

Paste the public SSH key from Hadoop master container into Spark client container´s authorized_keys
```shell
$ vi .ssh/authorized_keys    # append the ssh key from Hadoop master
```

Add the following parameters to $SPARK_HOME/conf/spark-defaults.conf
```shell
$ vi $SPARK_HOME/conf/spark-defaults.conf
spark.driver.memory  1024m
spark.yarn.am.memory 1024m
spark.executor.memory  1536m
```

Inside the Spark client container, run the following
```shell
$ export HADOOP_CONF_DIR=$SPARK_HOME/conf
$ spark-shell --master yarn
2021-12-05 11:09:14 WARN  NativeCodeLoader:62 - Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
Setting default log level to "WARN".
To adjust logging level use sc.setLogLevel(newLevel). For SparkR, use setLogLevel(newLevel).
2021-12-05 11:09:40 WARN  Client:66 - Neither spark.yarn.jars nor spark.yarn.archive is set, falling back to uploading libraries under SPARK_HOME.
Spark context Web UI available at http://802636b4d2b4:4040
Spark context available as 'sc' (master = yarn, app id = application_1638723680963_0001).
Spark session available as 'spark'.
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 2.3.2
      /_/
         
Using Scala version 2.11.8 (Java HotSpot(TM) 64-Bit Server VM, Java 1.8.0_181)
Type in expressions to have them evaluated.
Type :help for more information.

scala> 
```


