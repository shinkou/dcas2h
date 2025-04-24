FROM dcas2h-apps

ENV AIRFLOW_HOME=/home/airflow/airflow

RUN set -e \
	&& apt-get update \
	&& apt-get install -y libldap2-dev libsasl2-dev procps zip

COPY ./requirements.txt ./constraints.txt ./
RUN pip install --upgrade pip
RUN pip install -r ./requirements.txt --constraint ./constraints.txt
RUN curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip' \
	&& unzip ./awscliv2.zip \
	&& ./aws/install

COPY ./entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]

RUN groupadd airflow && useradd -r -m -g airflow -G hadoop -s /bin/bash airflow
USER airflow
RUN ssh-keygen -t rsa -q -N "" -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys

WORKDIR /home/airflow
EXPOSE 8080

# NOTE:
#   Use the following command to generate/update this "airflow_vars.json" file:
#   $ jq -s 'add' ./packages/common/configs/airflow/common_core_dev \
#   >   ./packages/common/configs/airflow/spark_configs_local \
#   >   ./packages/common/configs/airflow/personalised_deals_config_dev \
#   >   ./packages/common/configs/airflow/product_recommendations_gen_config_dev \
#   >   ./packages/common/configs/airflow/common_product_deals_config_dev}.json \
#   >   > ./tools/docker/localenv/airflow_vars.json
COPY ./vars.json /home/airflow/
