# core-site.xml (HADOOP e SPARK)
# =============
echo '<configuration>' >$HADOOP_HOME/etc/hadoop/core-site.xml
echo '  <property>' >>$HADOOP_HOME/etc/hadoop/core-site.xml
echo '    <name>fs.default.name</name>' >>$HADOOP_HOME/etc/hadoop/core-site.xml
echo '    <value>hdfs://'${HOSTNAME}':9000</value>' >>$HADOOP_HOME/etc/hadoop/core-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/core-site.xml
echo '  <property>' >>$SPARK_HOME/conf/core-site.xml
echo '    <name>hadoop.tmp.dir</name>' >>$SPARK_HOME/conf/core-site.xml
echo '    <value>/root/hadoop/hdata</value>' >>$SPARK_HOME/conf/core-site.xml
echo '  </property>' >>$SPARK_HOME/conf/core-site.xml
echo '</configuration>' >>$HADOOP_HOME/etc/hadoop/core-site.xml

# hdfs-site.xml (HADOOP e SPARK)
# =============
echo '<configuration>' >$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '  <property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <name>dfs.replication</name>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <value>2</value>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <name>dfs.name.dir</name>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <value>/hadoop/hdfs/namenode</value>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <name>dfs.data.dir</name>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '    <value>/hadoop/hdfs/datanode</value>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml

echo '</configuration>' >>$HADOOP_HOME/etc/hadoop/hdfs-site.xml

# mapred-site.xml (HADOOP)
# ===============
echo '<configuration>' >$HADOOP_HOME/etc/hadoop/mapred-site.xml
echo '  <property>' >>$HADOOP_HOME/etc/hadoop/mapred-site.xml
echo '    <name>mapreduce.framework.name</name>' >>$HADOOP_HOME/etc/hadoop/mapred-site.xml
echo '    <value>yarn</value>' >>$HADOOP_HOME/etc/hadoop/mapred-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/mapred-site.xml
echo '</configuration>' >>$HADOOP_HOME/etc/hadoop/mapred-site.xml

# yarn-site.xml (HADOOP)
# =============
echo '<configuration>' >$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <name>yarn.nodemanager.aux-services</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <value>mapreduce_shuffle</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <value>org.apache.hadoop.mapred.ShuffleHandler</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <name>yarn.resourcemanager.resource-tracker.address</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <value>'${HOSTNAME}':8025</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <name>yarn.resourcemanager.scheduler.address</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <value>'${HOSTNAME}':8030</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '  <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <name>yarn.resourcemanager.address</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    <value>'${HOSTNAME}':8040</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '  </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '    <property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '      <name>yarn.scheduler.maximum-allocation-mb</name>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '      <value>2048</value>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml
echo '    </property>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml

echo '</configuration>' >>$HADOOP_HOME/etc/hadoop/yarn-site.xml


# hadoop-env.sh (HADOOP)
# =============
echo '' >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export JAVA_HOME=/usr/local/jre1.8.0_181' >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true' >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh
echo 'export HADOOP_CONF_DIR='${HADOOP_HOME}'/etc/hadoop' >>$HADOOP_HOME/etc/hadoop/hadoop-env.sh
chmod +x $HADOOP_HOME/etc/hadoop/hadoop-env.sh
