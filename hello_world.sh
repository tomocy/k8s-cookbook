#!/bin/bash

echo 'create hello world deployment'
kubectl create deployment hello-node \
--image gcr.io/hello-minikube-zero-install/hello-node

echo 'expose hello world deployment'
kubectl expose deployment hello-node \
--type LoadBalancer \
--port 8080

IP=$(kubectl get service hello-node \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo 'The deployment of hello-node can be accessed by the following address'
echo ' http://${IP}:8080'

echo 'delete the deployment if you do not want to be charged by the following command'
echo ' kubectl delete service hello-node'
echo ' kubectl delete deployment hello-node'