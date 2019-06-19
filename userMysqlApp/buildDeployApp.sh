#!/bin/bash

eval $(minikube docker-env)

docker image pull mysql:5.6

# Build users_mysql app
docker build . -t users-mysql

# Check images status
docker image list

### Deploy to k8s

# mysql - deploy PV using PVC
kubectl create -f ../k8s_yaml/mysql-pv.yaml

# mysql - deploy single instance of MySQL
kubectl create -f ../k8s_yaml/mysql-deployment.yaml

kubectl create -f ../k8s_yaml/app.yaml

# Check, that app is running
kubectl get pods

