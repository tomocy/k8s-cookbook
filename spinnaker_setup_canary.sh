#/bin/bash

echo 'enable canary deployment'
hal config canary enable

echo 'enble storage for Kayenta with MinIO as S3s'
hal config canary aws enable
STORAGE_SECRET_KEY=$(kubectl get secret minio \
-n spinnaker \
-o jsonpath='{.data.secretkey}' | base64 --decode)
STORAGE_ACCESS_KEY=$(kubectl get secret minio \
-n spinnaker \
-o jsonpath='{.data.accesskey}' | base64 --decode)
STORAGE_ENDPOINT=http://minio:9000
echo ${STORAGE_SECRET_KEY} | hal config canary aws account add canary-s3-account \
--bucket spin-bucket \
--endpoint ${STORAGE_ENDPOINT} \
--access-key-id ${STORAGE_ACCESS_KEY} \
--secret-access-key
hal config canary aws edit --s3-enabled true
hal config canary edit --default-storage-account canary-s3-account

echo 'enable Prometheus'
hal config canary prometheus enable
hal config canary prometheus account add canary-metric-account \
--base-url http://prometheus-k8s.monitoring:9090
hal config canary edit --default-metrics-store prometheus

echo 'apply configurations'
hal deploy apply