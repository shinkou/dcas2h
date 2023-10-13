FROM dcas2h-spark

ARG HADOOP_VERSION
ARG SPARK_HOME
ARG SPARK_VERSION
ARG AWS_JAVA_SDK_VERSION
ARG POSTGRESQL_JDBC_VERSION

ENV HADOOP_VERSION=${HADOOP_VERSION:-3.3.6}
ENV SPARK_VERSION=${SPARK_VERSION:-3.5.0}
ENV SPARK_HOME=${SPARK_HOME:-/usr/lib/spark-${SPARK_VERSION}}
ENV AWS_JAVA_SDK_VERSION=${AWS_JAVA_SDK_VERSION:-1.11.1026}
ENV POSTGRESQL_JDBC_VERSION=${POSTGRESQL_JDBC_VERSION:-42.5.4}

ENV AWS_JAVA_SDK_JAR_URL="https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/$AWS_JAVA_SDK_VERSION/aws-java-sdk-bundle-${AWS_JAVA_SDK_VERSION}.jar"
ENV HADOOP_AWS_JAR_URL="https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-${HADOOP_VERSION}.jar"
ENV POSTGRESQL_JDBC_JAR_URL="https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRESQL_JDBC_VERSION}/postgresql-${POSTGRESQL_JDBC_VERSION}.jar"

RUN set -ex \
	&& curl -o "$(basename $AWS_JAVA_SDK_JAR_URL)" "$AWS_JAVA_SDK_JAR_URL" \
	&& curl -o "$(basename $HADOOP_AWS_JAR_URL)" "$HADOOP_AWS_JAR_URL" \
	&& curl -o "$(basename $POSTGRESQL_JDBC_JAR_URL)" "$POSTGRESQL_JDBC_JAR_URL" \
	&& mv $(basename $AWS_JAVA_SDK_JAR_URL) $SPARK_HOME/jars/ \
	&& mv $(basename $HADOOP_AWS_JAR_URL) $SPARK_HOME/jars/ \
	&& mv $(basename $POSTGRESQL_JDBC_JAR_URL) $SPARK_HOME/jars/
RUN pip install --upgrade pip \
	&& pip install boto3 boto-endpoint-url-shim jinja2 numpy pandas pyarrow redis requests scikit-learn[alldeps] seaborn
