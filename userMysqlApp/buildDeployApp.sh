#!/bin/bash

eval $(minikube docker-env)

# Build users_mysql app
docker build ...

# Check images status
docker image list

# Deploy to k8s

kubectl create -f ../k8s_yaml/mysql.yaml
kubectl create -f ../k8s_yaml/mysql-service.yaml
kubectl create -f ../k8s_yaml/app.yaml
kubectl create -f ../k8s_yaml/app-service.yaml

# Check, that app is running

kubectl get pods

