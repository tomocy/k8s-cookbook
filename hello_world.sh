#!/bin/bash

echo 'create hello world deployment'
kubectl create deployment hello-node \
--image gcr.io/hello-minikube-zero-install/hello-node

echo 'expose hello world deployment'
kubectl expose deployment hello-node \
--type LoadBalancer \
--port 8080