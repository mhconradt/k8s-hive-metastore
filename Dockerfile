FROM openjdk:8

WORKDIR /opt

ARG HADOOP_VERSION
ARG HIVE_VERSION
ARG AWS_JAVA_SDK_VERSION
ARG MYSQL_DRIVER_VERSION

ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/hive

# Install Hadoop and Hive binaries

RUN wget -q https://mirrors.ocf.berkeley.edu/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xzf hadoop-$HADOOP_VERSION.tar.gz
RUN mv hadoop-$HADOOP_VERSION $HADOOP_HOME
RUN rm hadoop-$HADOOP_VERSION.tar.gz

RUN wget -q https://mirrors.ocf.berkeley.edu/apache/hive/hive-$HIVE_VERSION/apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN tar -xzf apache-hive-${HIVE_VERSION}-bin.tar.gz
RUN mv apache-hive-${HIVE_VERSION}-bin $HIVE_HOME
RUN rm apache-hive-${HIVE_VERSION}-bin.tar.gz

# Install jars supporting S3A filesystem

RUN wget -q https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/$HADOOP_VERSION/hadoop-aws-$HADOOP_VERSION.jar
RUN wget -q https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/$AWS_JAVA_SDK_VERSION/aws-java-sdk-bundle-$AWS_JAVA_SDK_VERSION.jar

RUN mv hadoop-aws-$HADOOP_VERSION.jar \
        aws-java-sdk-bundle-$AWS_JAVA_SDK_VERSION.jar \
        $HADOOP_HOME/share/hadoop/common/lib

# Install MySQL JDBC driver for remote database access

RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-$MYSQL_DRIVER_VERSION.tar.gz | tar zxf -
RUN cp mysql-connector-java-$MYSQL_DRIVER_VERSION/mysql-connector-java-$MYSQL_DRIVER_VERSION.jar $HIVE_HOME/lib
RUN rm -rf mysql-connector-java-$MYSQL_DRIVER_VERSION

# Enforce Guava consistency
RUN rm $HIVE_HOME/lib/guava*
RUN find $HADOOP_HOME/share/hadoop/common/lib/ -name 'guava-*-jre.jar' -exec cp '{}' $HIVE_HOME/lib ';'

# Metastore runs on 9083 by default

COPY ./hadoop-conf /opt/hadoop/etc/hadoop
COPY ./hive-conf /opt/hive/conf

EXPOSE 9083

CMD ["/opt/hive/bin/hive", "--service", "metastore"]