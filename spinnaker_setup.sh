#/bin/bash

echo 'switch spinnaker account'
kubectl config use-context spinnaker-admin

echo 'enable Kubernetes'
ACCOUNT=k8s-v2-account
hal config provider kubernetes enable
hal config provider kubernetes account add ${ACCOUNT} \
--provider-version v2 \
--context $(kubectl config current-context)

echo 'install Spinnaker'
hal config deploy edit \
--type distributed \
--account-name ${ACCOUNT}

echo 'enable Artifacts'
hal config features edit --artifacts true

echo 'enable permanent storage with MinIO as S3'
STORAGE_SECRET_KEY=$(kubectl get secret minio \
-n spinnaker \
-o jsonpath='{.data.secretkey}' | base64 --decode)
STORAGE_ACCESS_KEY=$(kubectl get secret minio \
-n spinnaker \
-o jsonpath='{.data.accesskey}' | base64 --decode)
STORAGE_ENDPOINT=http://minio:9000
mkdir -p ~/.hal/default/profiles
echo 'spinnaker.s3.versioning: false' >> ~/.hal/default/profiles/profile.yaml
echo ${STORAGE_SECRET_KEY} | hal config storage s3 edit \
--endpoint ${STORAGE_ENDPOINT} \
--access-key-id ${STORAGE_ACCESS_KEY} \
--secret-access-key
hal config storage edit \
--type s3

echo 'enable docker registry with DockerHub'
hal config provider docker-registry enable
hal config provider docker-registry account add dockerhub \
--address index.docker.io \
--repositories 'tomocy/test' \
--username tomocy \
--password

echo 'set timezone in Asia/Tokyo'
hal config edit --timezone Asia/Tokyo

echo 'deploy Spinnaker ver1.13.8'
hal config version edit --version 1.13.8
hal deploy apply

echo 'expose Spinnaker deploy'
kubectl expose service spin-gate \
-n spinnaker \
--type LoadBalancer \
--port 8084 \
--target-port 8084 \
--name spin-gate-public
kubectl expose service spin-deck \
-n spinnaker \
--type LoadBalancer \
--port 9000 \
--target-port 9000 \
--name spin-deck-public
while true
do
API_ENDPOINT=$(kubectl get service spin-gate-public \
-n spinnaker \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
FRONTEND_ENDPOINT=$(kubectl get service spin-deck-public \
-n spinnaker \
-o jsonpath='{.status.loadBalancer.ingress[0].ip}')
if [ ! -z "${API_ENDPOINT}" -a ! -z "${FRONTEND_ENDPOINT}" ]
then
break
fi

sleep 1
done
hal config security api edit \
--override-base-url http://${API_ENDPOINT}:8084
hal config security ui edit \
--override-base-url http://${FRONTEND_ENDPOINT}:9000
hal deploy apply

echo 'You can delete Spinnaker deploy by the following command'
echo '  hal deploy clean'
