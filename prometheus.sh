#!/bin/bash

echo 'deploy Prometheus for metrics'
kubectl create -f manifests/setup
until kubectl get servicemonitors --all-namespaces
do date
sleep 1
echo ''
done
kubectl apply -f manifests/

echo 'expose Prometheus deploy'
kubectl expose service prometheus-k8s \
-n monitoring \
--type LoadBalancer \
--port 9090 \
--target-port 9090 \
--name prometheus-k8s-public

echo 'expose Grafana deploy'
kubectl expose service grafana \
-n monitoring \
--type LoadBalancer \
--port 3000 \
--target-port 3000 \
--name grafana-public

echo 'get the addresses of Prometheus and Grafana'
while true
do
PROMETHEUS_ENDPOINT=$(kubectl get service prometheus-k8s-public \
-n monitoring \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
GRAFANA_ENDPOINT=$(kubectl get service grafana-public \
-n monitoring \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ ! -z "${PROMETHEUS_ENDPOINT}" -a ! -z "${GRAFANA_ENDPOINT}" ]
then
break
fi

sleep 1
done
PROMETHEUS_ADDR="http://${PROMETHEUS_ENDPOINT}:9090"
GRAFANA_ADDR="http://${GRAFANA_ENDPOINT}:3000"
echo "You can access Prometheus via ${PROMETHEUS_ADDR}"
echo "You can access Grafana via ${GRAFANA_ADDR}"