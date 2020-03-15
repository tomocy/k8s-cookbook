#!/bin/bash

echo 'create hello world deployment'
kubectl create deployment hello-node \
--image gcr.io/hello-minikube-zero-install/hello-node

echo 'expose hello world deployment'
kubectl expose deployment hello-node \
--type LoadBalancer \
--port 8080

echo 'get the address of hello world deployment'
while true
do
IP=$(kubectl get service hello-node \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ ! -z "${IP}" ]
then
break
fi

sleep 1
done
echo 'Hello world deployment can be accessed by the following address'
echo "  http://${IP}:8080"

echo 'delete hello world deployment if you do not want to be charged by the following command'
echo '  kubectl delete service hello-node'
echo '  kubectl delete deployment hello-node'