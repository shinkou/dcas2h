FROM dcas2h-hadoop

ARG HIVE_CONF_DIR
ARG HIVE_VERSION

ENV HIVE_VERSION=${HIVE_VERSION:-4.0.1}
ENV HIVE_HOME=${HIVE_HOME:-/usr/lib/hive-${HIVE_VERSION}}
ENV HIVE_CONF_DIR=${HIVE_CONF_DIR:-${HIVE_HOME}/conf}
#ENV HIVE_BASE_URL="https://archive.apache.org/dist"
ENV HIVE_BASE_URL="https://dlcdn.apache.org"
ENV HIVE_URL="$HIVE_BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"
ENV PATH $HIVE_HOME/bin:$PATH
ENV JDBC_POSTGRESQL_VERSION=${JDBC_POSTGRESQL_VERSION:-42.7.5}
ENV JDBC_POSTGRESQL_URL="https://jdbc.postgresql.org/download/postgresql-$JDBC_POSTGRESQL_VERSION.jar"

WORKDIR /data

RUN set -x \
	&& curl -o ./KEYS -fSL "$HIVE_BASE_URL/hive/KEYS" \
	&& gpg --import ./KEYS \
	&& curl -o "$(basename $HIVE_URL)" "$HIVE_URL" \
	&& curl -o "$(basename $HIVE_URL).asc" "$HIVE_URL.asc" \
	&& gpg --verify "$(basename $HIVE_URL).asc" \
	&& tar -zxvf "$(basename $HIVE_URL)" \
	&& mkdir -p $(dirname $HIVE_HOME) \
	&& mv ./apache-hive-$HIVE_VERSION-bin $HIVE_HOME \
	&& echo "export HADOOP_HOME=$HADOOP_HOME" >> $HIVE_HOME/bin/hive-config.sh \
	&& rm ./KEYS ./$(basename $HIVE_URL) ./$(basename $HIVE_URL).asc
RUN set -x \
	&& curl -o "$(basename $JDBC_POSTGRESQL_URL)" "$JDBC_POSTGRESQL_URL" \
	&& mv ./$(basename $JDBC_POSTGRESQL_URL) $HIVE_HOME/lib/
RUN if [ ! -d $HIVE_CONF_DIR ]; then \
		mkdir -p $HIVE_CONF_DIR; \
	fi

COPY ./hive_conf_dir/* $HIVE_CONF_DIR/

EXPOSE 9083 10000
WORKDIR $HIVE_HOME/bin
ENTRYPOINT ["/bin/bash"]
CMD ["hive", "--service", "metastore"]
