#!/bin/bash

echo 'create namespace'
kubectl create namespace sock-shop

echo 'create docker registry ecret'
kubectl create secret docker-registry docker-secret \
-n sock-shop \
--docker-server index.docker.io \
--docker-username tomocy \
--docker-email tomocy.dev@gmail.com \
--docker-password