#!/bin/bash

echo 'create front end HPA'
kubectl apply \
-f ./front-end-hpa.yaml

echo 'You can watch HPA by the following commands'
echo '  kubectl get hpa -n sock-shop --watch'
echo '  kubectl get replicasets -n sock-shop -l name=front-end --watch'
echo ''
echo 'You can try HPA by increasing the load of front end by the following command'
echo '  kubectl run centos01 -it -n sock-shop --image centos --restart Never --rm'
echo '  while true; do curl -s -L http://front-end.sock-shop.svc.cluster.local > /dev/null ; done'
echo ''
echo 'You can delete HPA by the following command'
echo '  kubectl delete hpa front-end -n sock-shop'