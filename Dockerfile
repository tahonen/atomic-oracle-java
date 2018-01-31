FROM registry.access.redhat.com/rhel7-atomic
#ENV JRE_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jre-8u161-linux-x64.rpm
ENV JRE_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jre-9.0.4_linux-x64_bin.rpm
RUN curl -L -O -H "Cookie: oraclelicense=accept-securebackup-cookie"  ${JRE_DOWNLOAD_URL} && rpm -i jre*.rpm && rm -Rf jre*.rpm
RUN microdnf install tar --enablerepo=rhel-7-server-rpms && \
    microdnf update; microdnf clean all
    
RUN mkdir -p /deployments && chmod -R a+rwX /deployments

LABEL io.k8s.description="Platform for running Java (fatjar) with Oracle Java" \
      io.k8s.display-name="Java S2I binary builder 1.0" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,oraclejava,java,microservices,fatjar" \
      io.openshift.s2i.scripts-url=image:///usr/local/s2i
COPY ./s2i/bin/ /usr/local/s2i
RUN chmod -R 777 /usr/local/s2i
USER 1001
EXPOSE 8080
CMD ["usage"]
