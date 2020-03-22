#!/bin/bash

echo 'install packages for Istio 1.1.2'
curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.1.2 sh -

echo 'create service acccount and bind role for Tiller'
cd istio-1.1.2
kubectl apply -f install/kubernetes/helm/helm-service-account.yaml

echo 'create CRD for Istio'
kubectl apply -f insstall/kubernetes/helm/istio-install \
--name istio-install \
--namespace istio-system

echo 'install Istio on your cluster'
helm install install/kubernetes/helm/istio \
--name istio \
--namespace istio-system \
--set tracing.enabled=true \
--set pilot.traceSampling=100.0

echo ''
echo 'You should check that istio-ingressgateway has external ip address as LoadBalancer by the following command'
echo '  kubectl get service -n istio-system'
echo ''
echo 'You should check that all pods of istio system are running or completed by the following command'
echo '  kubectl get pods -n istio-system'