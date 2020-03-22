#!/bin/bash

echo 'create namespace'
kubectl create namespace sock-shop-with-mesh
kubectl label namespace sock-shop-with-mesh istio-injection=enabled

echo 'deploy sock shop'
kubectl apply \
-n sock-shop-with-mesh \
-f 10-sock-shop-complete-demo.yaml
kubectl apply -n sock-shop-with-mesh -f 20-sock-shop-gateway.yaml 
kubectl apply -n sock-shop-with-mesh -f 30-sock-shop-destinationrule.yaml 
kubectl apply -n sock-shop-with-mesh -f 40-sock-shop-virtualservices.yaml
while true
do
GATEWAY_ENDPOINT=$(kubectl get service istio-ingressgateway \
-n istio-system \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ ! -z "${GATEWAY_ENDPOINT}" ]
then
break
fi

sleep 1
done
ADDR="http://${GATEWAY_ENDPOINT}"
echo ''
echo "You can access your deploy via ${ADDR}"