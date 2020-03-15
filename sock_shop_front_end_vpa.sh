#!/bin/bash

echo 'create front end VPA'
kubectl apply \
-f ./front-end-vpa.yaml

echo 'You can watch HPA by the following commands'
echo '  kubectl describe vpa front-end -n sock-shop'
echo ''
echo 'You can try HPA by increasing the load of front end by the following command'
echo '  kubectl run centos01 -it -n sock-shop --image centos --restart Never --rm'
echo '  while true; do curl -s -L http://front-end.sock-shop.svc.cluster.local > /dev/null ; done'
echo ''
echo 'You can delete HPA by the following command'
echo '  kubectl delete vpa front-end -n sock-shop'