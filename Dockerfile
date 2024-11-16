FROM mkenjis/ubjava_img

#ARG DEBIAN_FRONTEND=noninteractive
#ENV TZ=US/Central

WORKDIR /usr/local

# wget https://archive.apache.org/dist/spark/spark-2.3.2/spark-2.3.2-bin-hadoop2.7.tgz
ADD spark-2.3.2-bin-hadoop2.7.tgz .

WORKDIR /root
RUN echo "" >>.bashrc \
 && echo 'export SPARK_HOME=/usr/local/spark-2.3.2-bin-hadoop2.7' >>.bashrc \
 && echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_HOME/lib/native' >>.bashrc \
 && echo 'export HADOOP_CONF_DIR=$SPARK_HOME/conf' >>.bashrc \
 && echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >>.bashrc

# authorized_keys already create in ubjava_img to enable containers connect to each other via passwordless ssh

COPY create_conf_files.sh .
RUN chmod +x create_conf_files.sh

COPY run_spark.sh .
RUN chmod +x run_spark.sh

COPY stop_spark.sh .
RUN chmod +x stop_spark.sh

EXPOSE 10000 7077 4040 8080 8081 8082

CMD /bin/bash -c "/root/run_spark.sh"; sleep infinity
