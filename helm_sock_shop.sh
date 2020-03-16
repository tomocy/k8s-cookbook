#!/bin/bash

echo 'lint sock shop chart'
helm lint sockshop

echo 'package sock shop chart'
helm package sockshop

echo 'deploy sock shop'
helm install --name sockshop --namespace sock-shop ./sockshop-0.2.0.tgz

echo 'get the address of sock shop deployment'
while true
do
IP=$(kubectl get service sockshop-nginx-ingress-controller \
-n sock-shop \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
PORT=$(kubectl get service sockshop-nginx-ingress-controller \
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
echo ''
echo 'delete sock shop deployment if you do not want to be charged by the following command'
echo '  helm delete --purge sockshop'
echo '  kubectl delete namespace sock-shop'