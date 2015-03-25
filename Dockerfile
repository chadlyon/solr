from centos:7

MAINTAINER "Chad Lyon" <chad.lyon@gmail.com>

ENV SOLR_VERSION 4.10.4
ENV SOLR solr-$SOLR_VERSION
ENV SOLR_USER solr

RUN yum -y update; yum clean all;

RUN yum -y install curl lsof procps emacs

RUN groupadd -r $SOLR_USER && useradd -r -g $SOLR_USER $SOLR_USER

VOLUME /opt

RUN wget -nv --output-document=/opt/$SOLR.tgz http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz && \
  tar -C /opt --extract --file /opt/$SOLR.tgz && \
  rm /opt/$SOLR.tgz && \
  ln -s /opt/$SOLR /opt/solr && \
  chown -R $SOLR_USER:$SOLR_USER /opt/solr /opt/$SOLR

EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER
CMD ["/bin/bash", "-c", "/opt/solr/bin/solr -f"]
