FROM debian

ENV JAVA_HOME=/usr/local/lib/adoptium-openjdk-8-jre-x64
ENV JAVA_DL_URL="https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u362-b09/OpenJDK8U-jre_x64_linux_hotspot_8u362b09.tar.gz"
ENV ZOOKEEPER_VERSION=${ZOOKEEPER_VERSION:-3.9.3}
ENV ZOOKEEPER_HOME=${ZOOKEEPER_HOME:-/usr/lib/zookeeper-${ZOOKEEPER_VERSION}}
#ENV ZOOKEEPER_BASE_URL="https://archive.apache.org/dist"
ENV ZOOKEEPER_BASE_URL="https://dlcdn.apache.org"
ENV ZOOKEEPER_URL="$ZOOKEEPER_BASE_URL/zookeeper/zookeeper-$ZOOKEEPER_VERSION/apache-zookeeper-$ZOOKEEPER_VERSION-bin.tar.gz"

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
	&& curl -o ./KEYS -fSL "$ZOOKEEPER_BASE_URL/zookeeper/KEYS" \
	&& gpg --import ./KEYS \
	&& curl -o "$(basename $ZOOKEEPER_URL)" "$ZOOKEEPER_URL" \
	&& curl -o "$(basename $ZOOKEEPER_URL).asc" "$ZOOKEEPER_URL.asc" \
	&& gpg --verify "$(basename $ZOOKEEPER_URL).asc" \
	&& tar -zxvf "$(basename $ZOOKEEPER_URL)" \
	&& mkdir -p "$(dirname $ZOOKEEPER_HOME)" \
	&& mv ./apache-zookeeper-$ZOOKEEPER_VERSION-bin $ZOOKEEPER_HOME \
	&& rm ./KEYS ./$(basename $ZOOKEEPER_URL) ./$(basename $ZOOKEEPER_URL).asc
RUN set -ex \
	&& mkdir -p $ZOOKEEPER_HOME/conf \
	&& mkdir /data/zookeeper \
	&& echo 'tickTime=2000' >> $ZOOKEEPER_HOME/conf/zoo.cfg \
	&& echo 'dataDir=/data/zookeeper' >> $ZOOKEEPER_HOME/conf/zoo.cfg \
	&& echo 'clientPort=2181' >> $ZOOKEEPER_HOME/conf/zoo.cfg

EXPOSE 2181
ENTRYPOINT ["/bin/bash"]
