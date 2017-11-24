FROM registry.access.redhat.com/rhel7-atomic
ENV JRE_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jre-8u152-linux-x64.rpm
RUN curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie"  ${JRE_DOWNLOAD_URL} && rpm -i jre*.rpm
RUN mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

LABEL io.k8s.description="Platform for running Java (fatjar) with Oracle Java" \
      io.k8s.display-name="Java S2I binary builder 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,oraclejava,java,microservices,fatjar" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./s2i/bin/ /usr/local/s2i
RUN chown -R 1001:1001 /opt/openshift && chmod -R a+rwX /usr/local/s2i
USER 1001
EXPOSE 8080
CMD ["usage"]
