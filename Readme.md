```
minikube start

kubectl get nodes

eval $(minikube docker-env)

cd start
mvn clean package

docker pull icr.io/appcafe/open-liberty:full-java11-openj9-ubi

docker images

kubectl apply -f kubernetes.yaml

kubectl get pods

MINIKUBE_IP=$(minikube ip)

curl "http://${MINIKUBE_IP}:31000/system/properties"

curl "http://${MINIKUBE_IP}:32000/inventory/systems/system-service"

kubectl scale deployment/system-deployment --replicas=3

kubectl get pods

curl -I "http://${MINIKUBE_IP}:31000/system/properties"

kubectl scale deployment/system-deployment --replicas=1

kubectl get pods

kubectl delete -f kubernetes.yaml

mvn clean package
docker build -t system:1.0-SNAPSHOT system/.
docker build -t inventory:1.0-SNAPSHOT inventory/.
kubectl apply -f kubernetes.yaml

mvn failsafe:integration-test -Ddockerfile.skip=true -Dsystem.service.root="$(minikube ip):31000" -Dinventory.service.root="$(minikube ip):32000"

kubectl delete -f kubernetes.yaml

eval $(minikube docker-env -u)

mvn liberty:devc

```