FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    wget \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://dl.influxdata.com/influxdb/releases/influxdb2-client-2.7.5-linux-amd64.tar.gz -O /tmp/influx2.tar.gz \
    && tar -xzf /tmp/influx2.tar.gz -C /tmp \
    && mv /tmp/influx /usr/local/bin/ \
    && rm -rf /tmp/influx2.tar.gz

RUN wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.13.0.deb -O /tmp/mongodb-tools.deb \
    && apt install -y /tmp/mongodb-tools.deb \
    && rm -rf /tmp/mongodb-tools.deb

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc \
    && chmod +x /usr/local/bin/mc

RUN mkdir -p /backups
WORKDIR /backups

COPY backup.sh /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/backup.sh

ENTRYPOINT ["/usr/local/bin/backup.sh"]
