#!/bin/bash
set -euxo pipefail

cd ./start

eval $(minikube docker-env)

mvn clean package -Dhttp.keepAlive=false -Dmaven.wagon.http.pool=false -Dmaven.wagon.httpconnectionManager.ttlSeconds=120

docker pull icr.io/appcafe/open-liberty:full-java11-openj9-ubi

docker build -t system:1.0-SNAPSHOT system/.
docker build -t inventory:1.0-SNAPSHOT inventory/.

kubectl apply -f kubernetes.yaml

kubectl get deployments

kubectl wait --for=condition=available --timeout=600s deployment/inventory-deployment
kubectl wait --for=condition=available --timeout=600s deployment/system-deployment

kubectl get pods

minikube ip

sleep 30

curl http://"$(minikube ip)":31000/system/properties
curl http://"$(minikube ip)":32000/inventory/systems

mvn failsafe:integration-test -Ddockerfile.skip=true -Dsystem.service.root="$(minikube ip):31000" -Dinventory.service.root="$(minikube ip):32000"
mvn failsafe:verify

kubectl logs "$(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep system)"
kubectl logs "$(kubectl get pods -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}' | grep inventory)"

kubectl delete -f kubernetes.yaml

eval $(minikube docker-env -u)

cd ..

