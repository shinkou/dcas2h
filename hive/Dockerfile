FROM dcas2h-hadoop

ARG HIVE_CONF_DIR
ARG HIVE_VERSION

ENV HIVE_VERSION=${HIVE_VERSION:-3.1.3}
ENV HIVE_HOME=${HIVE_HOME:-/usr/lib/hive-${HIVE_VERSION}}
ENV HIVE_CONF_DIR=${HIVE_CONF_DIR:-${HIVE_HOME}/conf}
#ENV HIVE_BASE_URL="https://archive.apache.org/dist"
ENV HIVE_BASE_URL="https://dlcdn.apache.org"
ENV HIVE_URL="$HIVE_BASE_URL/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz"
ENV PATH $HIVE_HOME/bin:$PATH

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
RUN if [ ! -d $HIVE_CONF_DIR ]; then \
		mkdir -p $HIVE_CONF_DIR; \
	fi

COPY ./hive_conf_dir/* $HIVE_CONF_DIR/

EXPOSE 9083 10000
WORKDIR $HIVE_HOME/bin
ENTRYPOINT ["/bin/bash"]
CMD ["hive", "--service", "metastore"]
