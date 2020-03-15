#!/bin/bash

echo 'create namespace'
kubectl create namespace sock-shop

echo 'create sock shop deployment'
kubectl apply \
-n sock-shop \
-f complete-demo.yaml

echo 'expose sock shop deployment'
kubectl expose deployment front-end \
-n sock-shop \
--type LoadBalancer \
--name front-end-svc

echo 'get the address of sock shop deployment'
while true
do
IP=$(kubectl get service front-end-svc \
-n sock-shop \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get service front-end-svc \
-n sock-shop \
-o jsonpath='{.spec.ports[0].port}')
if [ ! -z "${IP}" -a ! -z "${PORT}" ]
then
break
fi

sleep 1
done
echo 'Sock shop deployment can be accessed by the following address'
echo "  http://${IP}:${PORT}"

echo 'delete sock shop deployment if you do not want to be charged by the following command'
echo '  kubectl delete namespace sock-shop'