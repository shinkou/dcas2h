FROM python:3.8

ARG HADOOP_CONF_DIR
ARG HADOOP_HOME
ARG HADOOP_VERSION

# HiveServer2 needs Java 8
# More info about this Java 8 JRE at https://adoptium.net/
ENV JAVA_HOME=/usr/local/lib/adoptium-openjdk-8-jre-x64
ENV JAVA_DL_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u362-b09/OpenJDK8U-jre_x64_linux_hotspot_8u362b09.tar.gz"
ENV HADOOP_VERSION=${HADOOP_VERSION:-3.4.1}
ENV HADOOP_HOME=${HADOOP_HOME:-/usr/lib/hadoop-${HADOOP_VERSION}}
ENV HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-${HADOOP_HOME}/etc/hadoop}
#ENV HADOOP_BASE_URL="https://archive.apache.org/dist"
ENV HADOOP_BASE_URL="https://dlcdn.apache.org"
ENV HADOOP_URL="$HADOOP_BASE_URL/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz"
ENV ARROW_LIBHDFS_DIR=$HADOOP_HOME/lib/native
ENV PATH $HADOOP_HOME/sbin:$HADOOP_HOME/bin:$JAVA_HOME/bin:$PATH
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
ENV YARN_HOME=$HADOOP_HOME
ENV YARN_CONF_DIR=$HADOOP_CONF_DIR

WORKDIR /data

RUN set -e \
	&& apt-get update \
	&& apt-get install -y curl gpg gpg-agent netcat-openbsd ssh wget
RUN set -ex \
	&& wget $JAVA_DL_URL \
	&& tar -zxvf ./$(basename $JAVA_DL_URL) \
	&& mv ./jdk8u362-b09-jre $JAVA_HOME \
	&& rm ./$(basename $JAVA_DL_URL)
RUN set -ex \
	&& curl -o ./KEYS -fSL "$HADOOP_BASE_URL/hadoop/common/KEYS" \
	&& gpg --import ./KEYS \
	&& curl -o "$(basename $HADOOP_URL)" "$HADOOP_URL" \
	&& curl -o "$(basename $HADOOP_URL).asc" "$HADOOP_URL.asc" \
	&& gpg --verify "$(basename $HADOOP_URL).asc" \
	&& tar -zxvf "$(basename $HADOOP_URL)" \
	&& mkdir -p $(dirname $HADOOP_HOME) \
	&& mv ./hadoop-$HADOOP_VERSION $HADOOP_HOME \
	&& mkdir $HADOOP_HOME/logs \
	&& mv $HADOOP_HOME/etc/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh.default \
	&& rm ./KEYS ./$(basename $HADOOP_URL) ./$(basename $HADOOP_URL).asc
RUN groupadd hadoop \
	&& usermod -g root -G hadoop root \
	&& useradd -r -m -g hadoop -s /bin/bash hadoop \
	&& chown -R hadoop:hadoop $HADOOP_HOME && chmod -R 0775 $HADOOP_HOME
USER hadoop
RUN ssh-keygen -t rsa -q -N "" -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
USER root
RUN ssh-keygen -t rsa -q -N "" -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
RUN if [ ! -d $HADOOP_CONF_DIR ]; then \
		mkdir -p $HADOOP_CONF_DIR; \
		if [ "$HADOOP_CONF_DIR" != "$HADOOP_HOME/etc/hadoop" ]; then \
			cp "$HADOOP_HOME/etc/hadoop/capacity-scheduler.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/configuration.xsl" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/container-executor.cfg" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/core-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/hadoop-env.sh.default" "$HADOOP_CONF_DIR/hadoop-env.sh"; \
			cp "$HADOOP_HOME/etc/hadoop/hadoop-metrics2.properties" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/hadoop-policy.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/hdfs-rbf-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/hdfs-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/httpfs-env.sh" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/httpfs-log4j.properties" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/httpfs-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/kms-acls.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/kms-env.sh" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/kms-log4j.properties" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/kms-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/log4j.properties" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/mapred-env.sh" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/mapred-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/workers" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/yarn-env.sh" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/yarn-site.xml" "$HADOOP_CONF_DIR/"; \
			cp "$HADOOP_HOME/etc/hadoop/yarnservice-log4j.properties" "$HADOOP_CONF_DIR/"; \
		fi; \
		chmod g+x $HADOOP_CONF_DIR; \
		chown hadoop:hadoop $HADOOP_CONF_DIR; \
	fi
RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export HDFS_DATANODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh \
	&& echo "export YARN_PROXYSERVER_USER=root" >> $HADOOP_CONF_DIR/hadoop-env.sh

COPY ./hadoop_conf_dir/* $HADOOP_CONF_DIR/
COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []
