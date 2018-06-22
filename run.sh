#!/usr/bin/env bash

set -e

minikube delete || true

echo "==> Create minikube…"
minikube start \
  --memory=13312 \
  --cpus=9 \
  --disk-size=30g

set +e
echo "==> Waiting for Kubernetes…"
for i in {1..150}; do # timeout for 5 minutes
    kubectl get po &> /dev/null
    if [ $? -ne 1 ]; then
        break
    fi
    sleep 2
    echo "    …"
done
set -e

echo "==> Initializing Helm…"
helm init

set +e
echo "==> Waiting for Helm…"
for i in {1..150}; do # timeout for 5 minutes
    helm list &> /dev/null
    if [ $? -ne 1 ]; then
        break
    fi
    sleep 2
    echo "    …"
done
set -e

echo "==> Installing Heron…"
helm repo add heron-charts https://storage.googleapis.com/heron-charts
helm install heron-charts/heron \
            --name heron \
            --namespace heron
            # \ --set platform=minikube

echo "==> Heron UI web:"
kubectl expose deployment --namespace heron heron-tools --type=NodePort --name=heron-web --port=8889
minikube service -n heron --url heron-web

echo "==> Installing Heron…"
heron config heron set service_url `minikube service -n heron --url heron-apiserver`

cd word_count
./build.sh
