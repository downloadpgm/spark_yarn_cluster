FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Central

RUN apt-get update && apt-get install -y supervisor openssh-server openssh-client vim iputils-ping python

WORKDIR /usr/local

# git clone https://github.com/mkenjis/apache_binaries
ADD jre-8u181-linux-x64.tar.gz .
# wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
ADD hadoop-2.7.3.tar.gz .

WORKDIR /root
RUN echo "" >>.bashrc \
 && echo 'export JAVA_HOME=/usr/local/jre1.8.0_181' >>.bashrc \
 && echo 'export CLASSPATH=$JAVA_HOME/lib' >>.bashrc \
 && echo 'export PATH=$PATH:.:$JAVA_HOME/bin' >>.bashrc \
 && echo "" >>.bashrc \
 && echo 'export HADOOP_HOME=/usr/local/hadoop-2.7.3' >>.bashrc \
 && echo 'export HADOOP_MAPRED_HOME=$HADOOP_HOME' >>.bashrc \
 && echo 'export HADOOP_COMMON_HOME=$HADOOP_HOME' >>.bashrc \
 && echo 'export HADOOP_HDFS_HOME=$HADOOP_HOME' >>.bashrc \
 && echo 'export YARN_HOME=$HADOOP_HOME' >>.bashrc \
 && echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native' >>.bashrc \
 && echo 'export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >>.bashrc
 
RUN /usr/bin/bash -c "ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>&1 >/dev/null" \
 && cp .ssh/id_rsa.pub .ssh/authorized_keys
 
COPY create_conf_files.sh .
RUN chmod +x create_conf_files.sh

COPY run_hadoop.sh .
RUN chmod +x run_hadoop.sh

COPY stop_hadoop.sh .
RUN chmod +x stop_hadoop.sh

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 9000

CMD ["/usr/bin/supervisord"]
