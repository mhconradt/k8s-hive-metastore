# k8s-hive-metastore
Dockerfile and Kubernetes setup for a Hive metastore.


## Build Configuration

Specify versions of Hadoop, Hive, MySQL Connector and AWS SDK for Java.

<code>
docker build -t my.registry.com/repository:tag \
        --build-arg HADOOP_VERSION=3.3.0 \
        --build-arg HIVE_VERSION=3.1.2 \
        --build-arg MYSQL_DRIVER_VERSION=8.0.20 \
        --build-arg AWS_JAVA_SDK_VERSION=1.11.563 .
</code>


<br/>
<br/>


Edit configuration files in the <code>hive-conf</code> and <code>hadoop-conf</code> directories. <br/>
The files <code>./hadoop-conf/core-site.xml</code> and <code>./hive-conf/hive-site.xml</code>
contain configurations for the S3A filesystem and remote database, respectively.

## Kubernetes Configuration

Edit the configurations for the metastore deployment and service in
the <code>./kubernetes</code> directory.

## Command Shortcuts

Update the Docker image:

<code>just update_image</code>

<br/>

Update the Kubernetes configuration:

<code>just update_k8s</code>