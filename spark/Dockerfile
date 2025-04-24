FROM dcas2h-hadoop

ARG SPARK_CONF_DIR
ARG SPARK_HOME
ARG SPARK_VERSION

ENV SPARK_VERSION=${SPARK_VERSION:-3.5.5}
ENV SPARK_HOME=${SPARK_HOME:-/usr/lib/spark-${SPARK_VERSION}}
ENV SPARK_CONF_DIR=${SPARK_CONF_DIR:-${SPARK_HOME}/conf}
#ENV SPARK_BASE_URL="https://archive.apache.org/dist"
ENV SPARK_BASE_URL="https://dlcdn.apache.org"
ENV SPARK_URL="$SPARK_BASE_URL/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz"
ENV PATH $SPARK_HOME/bin:$PATH

RUN set -ex \
	&& curl -o ./spark-bin-hadoop3.tgz "$SPARK_URL" \
	&& tar -zxvf ./spark-bin-hadoop3.tgz \
	&& mkdir -p $(dirname $SPARK_HOME) \
	&& mv ./spark-${SPARK_VERSION}-bin-hadoop3 $SPARK_HOME

COPY ./spark_conf_dir/* $SPARK_CONF_DIR/
RUN echo "spark.driver.extraLibraryPath $HADOOP_HOME/lib/native" >> $SPARK_CONF_DIR/spark-defaults.conf \
	&& echo "spark.executor.extraLibraryPath $HADOOP_HOME/lib/native" >> $SPARK_CONF_DIR/spark-defaults.conf
RUN echo "#!/usr/bin/env bash" >> $SPARK_CONF_DIR/spark-env.sh \
	&& echo "export HADOOP_HOME=$HADOOP_HOME" >> $SPARK_CONF_DIR/spark-env.sh \
	&& echo "export HADOOP_CONF_DIR=$HADOOP_CONF_DIR" >> $SPARK_CONF_DIR/spark-env.sh \
	&& chmod +x $SPARK_CONF_DIR/spark-env.sh
RUN chown -R hadoop:hadoop $HADOOP_CONF_DIR $SPARK_CONF_DIR

ENTRYPOINT ["/bin/bash"]
CMD ["-c", "$$SPARK_HOME/sbin/start-thriftserver.sh"]
