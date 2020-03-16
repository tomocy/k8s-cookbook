#!/bin/bash

echo 'deploy prometheus operator'
kubectl apply \
-f prometheus-operator

echo 'create cluster role binding to prometheus'
kubectl apply \
-f prometheus

echo 'deploy monitors'
kubectl apply \
-f service-monitors

echo 'deploy prometheus'
kubectl apply \
-f prometheus.yaml

echo 'create prometheus service'
kubectl apply \
-f svc-prometheus.yaml

echo 'get the address of prometheus deployment'
while true
do
IP=$(kubectl get service prometheus \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get service prometheus \
-o jsonpath='{.spec.ports[0].port}')
if [ ! -z "${IP}" -a  ! -z "${PORT}" ]
then
break
fi

sleep 1
done
echo 'Prometheus deployment can be accessed by the following address'
echo "  http://${IP}:${PORT}"
echo ''
echo 'delete prometheus deployment by the following command'
echo '  kubectl delete service prometheus'
echo '  kubectl delete prometheus prometheus'
echo '  kubectl delete -f service-monitors'
echo '  kubectl delete -f prometheus'
echo '  kubectl delete -f prometheus-operator'
echo '  kubectl delete customresourcedefinitions prometheuses.monitoring.coreos.com servicemonitors.monitoring.coreos.com alertmanagers.monitoring.coreos.com prometheusrules.monitoring.coreos.com'
