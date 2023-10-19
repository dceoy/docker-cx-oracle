FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py
ADD https://download.oracle.com/otn_software/linux/instantclient/2111000/instantclient-basic-linux.x64-21.11.0.0.0dbru.zip /tmp/oracle-instantclient.zip

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https ca-certificates curl libaio-dev python3 \
        python3-distutils unzip \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && mkdir -p /opt/oracle \
      && unzip /tmp/oracle-instantclient.zip -d /opt/oracle \
      && mv /opt/oracle/instantclient_* /opt/oracle/instantclient

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir pip \
      && pip install -U --no-cache-dir cx_Oracle

ENV LD_LIBRARY_PATH /opt/oracle/instantclient

ENTRYPOINT ["/usr/bin/python"]
