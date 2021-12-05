trap "{ echo Stopping play app; /root/stop_hadoop.sh; exit 0; }" SIGTERM

export JAVA_HOME=/usr/local/jre1.8.0_181
export CLASSPATH=$JAVA_HOME/lib
export PATH=$PATH:.:$JAVA_HOME/bin

export HADOOP_HOME=/usr/local/hadoop-2.7.3
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

service ssh start

echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
ssh-keyscan ${HOSTNAME} >~/.ssh/known_hosts
ssh-keyscan localhost >>~/.ssh/known_hosts
ssh-keyscan 0.0.0.0 >>~/.ssh/known_hosts

if [ -n "${HADOOP_HOST_SLAVES}" ]; then

   sleep 30
   
   create_conf_files.sh

   >${HADOOP_CONF_DIR}/slaves
   
   for HADOOP_HOST in `echo ${HADOOP_HOST_SLAVES} | tr ',' ' '`; do
      ssh-keyscan ${HADOOP_HOST} >~/.ssh/known_hosts
	  scp ${HADOOP_CONF_DIR}/core-site.xml root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/core-site.xml
	  scp ${HADOOP_CONF_DIR}/hdfs-site.xml root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/hdfs-site.xml
	  scp ${HADOOP_CONF_DIR}/mapred-site.xml root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/mapred-site.xml
	  scp ${HADOOP_CONF_DIR}/yarn-site.xml root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/yarn-site.xml
	  scp ${HADOOP_CONF_DIR}/hadoop-env.sh root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/hadoop-env.sh
	  
      ssh root@${HADOOP_HOST} "cat /etc/hostname" >>${HADOOP_CONF_DIR}/slaves
   done
   
   for HADOOP_HOST in `echo ${HADOOP_HOST_SLAVES} | tr ',' ' '`; do
 	  scp ${HADOOP_CONF_DIR}/slaves root@${HADOOP_HOST}:${HADOOP_CONF_DIR}/slaves
   done   

   # build HDFS 
   $HADOOP_HOME/bin/hdfs namenode -format

   # start HDFS and YARN services
   $HADOOP_HOME/sbin/start-dfs.sh
   $HADOOP_HOME/sbin/start-yarn.sh
fi
