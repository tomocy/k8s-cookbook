#!/bin/bash

echo 'get service address'
IP=$(kubectl get service nginx-svc \
-o jsonpath='{.spec.clusterIP}')
PORT=$(kubectl get service nginx-svc \
-o jsonpath='{.spec.ports[0].port}')
ADDRESS="http://${IP}:${PORT}"
echo 'You can access your deployment via the following address only in your cluster'
echo "  ${ADDRESS}"
echo 'Example: access your deployment from CentOS pod in your cluster'
echo "  kubectl run centos01 -it --rm --image centos --restart Never --env ADDRESS=${ADDRESS}"
echo "  curl ${ADDRESS}"