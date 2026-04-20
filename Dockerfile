ARG ELASTIC_VERSION=9.4.0

FROM docker.elastic.co/logstash/logstash:${ELASTIC_VERSION}

COPY logstash/pipeline/logstash.conf /usr/share/logstash/pipeline/logstash.conf
COPY logstash/config/logstash.yml /usr/share/logstash/config/logstash.yml

EXPOSE 5044 5000 9600
