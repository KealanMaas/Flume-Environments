FROM ubuntu:14.04 AS hadoop

RUN useradd -s /bin/bash user

USER root
WORKDIR /root

ENV HADOOP_VERSION 2.7.7
ENV HADOOP_PREFIX /opt/hadoop


# Install all dependencies
RUN apt-get update && apt-get install -y wget ssh rsync net-tools curl
# Install OpenJDK-8
RUN apt-get update && apt-get install -y software-properties-common
# Get openjdk-jre from ppa repository
RUN add-apt-repository ppa:openjdk-r/ppa
# Install wget and openjdk8-jre
RUN apt-get update && apt-get install -y openjdk-8-jdk && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
# Set Java home in the environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME


# Download hadoop.
RUN wget -O /tmp/hadoop-${HADOOP_VERSION}.tar.gz https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && wget -O /tmp/hadoop-${HADOOP_VERSION}.tar.gz.mds  https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.mds

# Install hadoop
RUN tar -C /opt -xf /tmp/hadoop-${HADOOP_VERSION}.tar.gz \
    && ln -s /opt/hadoop-${HADOOP_VERSION} ${HADOOP_PREFIX} \
    && mkdir /var/lib/hadoop

# Install ssh key
RUN ssh-keygen -q -t dsa -P '' -f /root/.ssh/id_dsa \
    && cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys

# Config ssh to accept all connections from unknow hosts.
COPY config/ssh_config /root/.ssh/config

# Copy Hadoop config files
COPY config/hadoop-env.sh ${HADOOP_PREFIX}/etc/hadoop/
COPY config/core-site.xml ${HADOOP_PREFIX}/etc/hadoop/
COPY config/hdfs-site.xml ${HADOOP_PREFIX}/etc/hadoop/
COPY config/mapred-site.xml ${HADOOP_PREFIX}/etc/hadoop/
COPY config/yarn-site.xml ${HADOOP_PREFIX}/etc/hadoop/


# Format hdfs
RUN ${HADOOP_PREFIX}/bin/hdfs namenode -format

# Copy the entry point shell
COPY config/docker_entrypoint.sh /root/
RUN chmod a+x /root/docker_entrypoint.sh

# Folder to share files
RUN mkdir /root/shared && \
    chmod a+rwX /root/shared

# Clean
RUN rm -r /var/cache/apt /var/lib/apt/lists /tmp/hadoop-${HADOOP_VERSION}.tar*


################### Expose ports

### Core

# Zookeeper
EXPOSE 2181

# NameNode metadata service ( fs.defaultFS )
EXPOSE 9000

# FTP Filesystem impl. (fs.ftp.host.port)
EXPOSE 21

### Hdfs ports (Reference: https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml)

# NameNode Web UI: Web UI to look at current status of HDFS, explore file system (dfs.namenode.http-address / dfs.namenode.https-address)
EXPOSE 50070 50470

# DataNode : DataNode WebUI to access the status, logs etc. (dfs.datanode.http.address / dfs.datanode.https.address)
EXPOSE 50075 50475

# DataNode  (dfs.datanode.address / dfs.datanode.ipc.address)
EXPOSE 50010 50020

# Secondary NameNode (dfs.namenode.secondary.http-address / dfs.namenode.secondary.https-address)
EXPOSE 50090 50090

# Backup node (dfs.namenode.backup.address / dfs.namenode.backup.http-address)
EXPOSE 50100 50105

# Journal node (dfs.journalnode.rpc-address / dfs.journalnode.http-address / dfs.journalnode.https-address )
EXPOSE 8485 8480 8481

### Mapred ports (Reference: https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/mapred-default.xml)

# Task Tracker Web UI and Shuffle (mapreduce.tasktracker.http.address)
EXPOSE 50060

# Job tracker Web UI (mapreduce.jobtracker.http.address)
EXPOSE 50030

# Job History Web UI (mapreduce.jobhistory.webapp.address)
EXPOSE 19888

# Job History Admin Interface (mapreduce.jobhistory.admin.address)
EXPOSE 10033

# Job History IPC (mapreduce.jobhistory.address)
EXPOSE 10020

### Yarn ports (Reference: https://hadoop.apache.org/docs/stable/hadoop-yarn/hadoop-yarn-common/yarn-default.xml)

# Applications manager interface (yarn.resourcemanager.address)
EXPOSE 8032

# Scheduler interface (yarn.resourcemanager.scheduler.address)
EXPOSE 8030

# Resource Manager Web UI (yarn.resourcemanager.webapp.address / yarn.resourcemanager.webapp.https.address)
EXPOSE 8088 8090

# ??? (yarn.resourcemanager.resource-tracker.address)
EXPOSE 8031

# Resource Manager Administration Web UI
EXPOSE 8033

# Address where the localizer IPC is (yarn.nodemanager.localizer.address)
EXPOSE 8040

# Node Manager Web UI (yarn.nodemanager.webapp.address)
EXPOSE 8042

# Timeline servise RPC (yarn.timeline-service.address)
EXPOSE 10200

# Timeline servise Web UI (yarn.timeline-service.webapp.address / yarn.timeline-service.webapp.https.address)
EXPOSE 8188 8190

# Shared Cache Manager Admin Web UI (yarn.sharedcache.admin.address)
EXPOSE 8047

# Shared Cache Web UI (yarn.sharedcache.webapp.address)
EXPOSE 8788

# Shared Cache node manager interface (yarn.sharedcache.uploader.server.address)
EXPOSE 8046

# Shared Cache client interface (yarn.sharedcache.client-server.address)
EXPOSE 8045

### Other ports

# SSH
EXPOSE 22



################### Expose volumes
VOLUME ["/opt/hadoop/logs", "/root/shared"]

WORKDIR /root
################### Entry point
ENTRYPOINT [ "/root/docker_entrypoint.sh" ]




FROM ubuntu:14.04 AS flume
RUN useradd -s /bin/bash user

USER root
WORKDIR /root

ENV FLUME_VERSION 1.9.0
ENV FLUME_PREFIX /opt/flume

# Install all dependencies
RUN apt-get update && apt-get install -y wget ssh rsync net-tools curl
# Install OpenJDK-8
RUN apt-get update && apt-get install -y software-properties-common
# Get openjdk-jre from ppa repository
RUN add-apt-repository ppa:openjdk-r/ppa
# Install wget and openjdk8-jre
RUN apt-get update && apt-get install -y openjdk-8-jdk && apt-get install -y wget && rm -rf /var/lib/apt/lists/*
# Set Java home in the environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

# Download flume.
RUN wget -O /tmp/flume-${FLUME_VERSION}.tar.gz https://www.apache.org/dist/flume/$FLUME_VERSION/apache-flume-${FLUME_VERSION}-bin.tar.gz \
    && wget -O /tmp/flume-${FLUME_VERSION}.tar.gz.asc  https://www.apache.org/dist/flume/$FLUME_VERSION/apache-flume-${FLUME_VERSION}-bin.tar.gz.asc

# Install flume
RUN tar -C /opt -xf /tmp/flume-${FLUME_VERSION}.tar.gz \
    && mkdir /var/lib/flume \
    && mv /opt/apache-flume-${FLUME_VERSION}-bin /opt/flume \ 
    && ln -s /opt/apache-flume-${FLUME_VERSION}-bin ${FLUME_PREFIX} 

ENV HADOOP_VERSION 2.7.7
ENV HADOOP_PREFIX /opt/hadoop

# Download hadoop.
RUN wget -O /tmp/hadoop-${HADOOP_VERSION}.tar.gz https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz \
    && wget -O /tmp/hadoop-${HADOOP_VERSION}.tar.gz.mds  https://www.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.mds

# Install hadoop
RUN tar -C /opt -xf /tmp/hadoop-${HADOOP_VERSION}.tar.gz \
    && ln -s /opt/hadoop-${HADOOP_VERSION} ${HADOOP_PREFIX} \
    && mkdir /var/lib/hadoop

RUN wget -O dd-java-agent.jar https://dtdg.co/latest-java-tracer

# Install ssh key
RUN ssh-keygen -q -t dsa -P '' -f /root/.ssh/id_dsa \
    && cat /root/.ssh/id_dsa.pub >> /root/.ssh/authorized_keys

# Config ssh to accept all connections from unknow hosts.
COPY config/ssh_config /root/.ssh/config

# Copy Flume config files
COPY config/flume-env.sh ${FLUME_PREFIX}/conf/flume-env.sh
COPY config/hello-world.conf ${FLUME_PREFIX}/conf/hello-world.conf

COPY config/test.log /opt/test.log


#FLUME JMX PORT 
EXPOSE 7199


WORKDIR /opt/flume 
ENTRYPOINT ["bin/flume-ng", "agent"]
CMD ["-n", "hdfs-agent", "-c", "conf", "-f", "conf/hello-world.conf", "-Dflume.root.logger=INFO,console"]

