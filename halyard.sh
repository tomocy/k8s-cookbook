#!/bin/bash

echo 'create hal credential'
mkdir -vp ~/.hal/kube
cp -i ~/.kube/config ~/.hal/kube/

echo 'run Halyard'
docker run \
-p 8084:8084 \
-p 9000:9000 \
-d \
--rm \
--name halyard \
-v ~/.hal/kube:/home/spinnaker/.kube \
-v ~/.hal:/home/spinnaker/.hal \
-e KUBECONFIG=/home/spinnaker/.kube/config \
gcr.io/spinnaker-marketplace/halyard:1.20.2

echo 'You can enter halyard container by the following command'
echo '  docker exec -it halyard /bin/bash'