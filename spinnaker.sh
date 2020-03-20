#!/bin/bash

echo 'create namespace'
kubectl create namespace spinnaker

echo 'create service account'
kubectl create serviceaccount spinnaker-sa \
-n spinnaker

echo 'bind role'
kubectl create clusterrolebinding spinnaker-rb \
--save-config \
--clusterrole cluster-admin \
--serviceaccount spinnaker:spinnaker-sa

echo 'save credentials'
SECRET=$(kubectl get sa spinnaker-sa \
-n spinnaker \
-o jsonpath='{.secrets[0].name}')
TOKEN=$(kubectl get secret ${SECRET} \
-n spinnaker \
-o jsonpath='{.data.token}')
kubectl config set-credentials spinnaker \
--token ${TOKEN}
kubectl config set-context spinnaker-admin \
--namespace spinnaker
--user spinnaker
--cluster aks01
