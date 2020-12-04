image := '452355156841.dkr.ecr.us-east-1.amazonaws.com/metastore:prototype'
namespace := 'aux'

update_image:
    docker build -t {{image}} \
        --build-arg HADOOP_VERSION=3.3.0 \
        --build-arg HIVE_VERSION=3.1.2 \
        --build-arg MYSQL_DRIVER_VERSION=8.0.20 \
        --build-arg AWS_JAVA_SDK_VERSION=1.11.563 .
    docker push {{image}}

update_k8s:
    kubectl apply -n {{namespace}} -f ./kubernetes

update: update_image update_k8s