from centos:7

MAINTAINER "Chad Lyon" <chad.lyon@gmail.com>

ENV SOLR_VERSION 4.10.4
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_JETTY /usr/local/$SOLR
ENV SOLR_HOME /var/lib/solr
ENV JAVA_VERSION 1.7.0.71
ENV JAVA_HOME /usr/lib/jvm/jre

RUN yum -y update && \
    yum -y install wget curl tar lsof procps emacs && \
    yum -y install java-1.7.0-openjdk-headless-$JAVA_VERSION && \
    yum -y clean all

RUN curl http://www.mirrorservice.org/sites/ftp.apache.org/lucene/solr/$SOLR_VERSION/$SOLR.tgz | \
    tar -xz -C /tmp/ --exclude $SOLR/example/example* --exclude $SOLR/example/multicore --exclude $SOLR/example/solr/collection1 --strip-components=1 $SOLR/example && \
    mv /tmp/example $SOLR_JETTY && \
    mv $SOLR_JETTY/solr $SOLR_HOME && \
    mkdir -p /var/log/solr && \
    sed -i 's:^\(solr.log=\).*:\1/var/log/solr/:g' $SOLR_JETTY/resources/log4j.properties

EXPOSE 8983
VOLUME ["$SOLR_HOME", "/var/log/solr"]

WORKDIR $SOLR_JETTY
CMD ["java", "-Dsolr.solr.home=/var/lib/solr", "-jar", "start.jar"]
