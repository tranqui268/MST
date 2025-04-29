FROM eclipse-temurin:18-jdk-focal

RUN apt-get update && apt-get install -y curl tar && rm -rf /var/lib/apt/lists/*


ENV JETTY_VERSION=9.4.53.v20231009
RUN mkdir -p /opt/jetty && \
    curl -SL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${JETTY_VERSION}/jetty-distribution-${JETTY_VERSION}.tar.gz | tar -xz -C /opt/jetty --strip-components=1 && \
    ls -l /opt/jetty/ && \
    chmod -R 755 /opt/jetty

ENV JETTY_HOME=/opt/jetty
ENV PATH=$JETTY_HOME/bin:$PATH


RUN mkdir -p /opt/jetty/webapps && \
    chmod -R 755 /opt/jetty/webapps


WORKDIR /opt/jetty
RUN java -jar start.jar --add-to-start=deploy


RUN mkdir -p /opt/jetty/resources && \
    echo "org.eclipse.jetty.LEVEL=DEBUG" > /opt/jetty/resources/jetty-logging.properties && \
    echo "org.eclipse.jetty.util.log.stderr.STACKS=true" >> /opt/jetty/resources/jetty-logging.properties


COPY target/basic-struts.war /opt/jetty/webapps/


EXPOSE 8080

CMD ["java", "-Djetty.logging.dir=/opt/jetty/logs", "-Djava.util.logging.config.file=/opt/jetty/resources/jetty-logging.properties", "-jar", "/opt/jetty/start.jar"]