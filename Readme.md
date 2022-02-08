```
minikube start

kubectl get nodes

eval $(minikube docker-env)

cd start
mvn clean package

docker pull icr.io/appcafe/open-liberty:full-java11-openj9-ubi

docker images

kubectl apply -f kubernetes.yaml

kubectl get deployments

kubectl wait --for=condition=available --timeout=600s deployment/inventory-deployment
kubectl wait --for=condition=available --timeout=600s deployment/system-deployment

kubectl get pods

MINIKUBE_IP=$(minikube ip)

curl "http://$(minikube ip):31000/system/properties"

curl -I "http://$(minikube ip):31000/system/properties"

curl "http://$(minikube ip):32000/inventory/systems/system-service"

curl -I "http://$(minikube ip):32000/inventory/systems/system-service"

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


# Development in container
cd system
mvn liberty:devc -Dsystem.service.root="$(minikube ip):31000" 

cd inventory
mvn liberty:devc -Dinventory.service.root="$(minikube ip):32000" -Dsystem.service.root="$(minikube ip):31000"


tail -f /tmp/minikube.log


#Istio
istioctl install --set profile=demo -y

kubectl get deployments -n istio-system

kubectl label namespace default istio-injection=enabled

mvn clean package
docker build -t system:1.0-SNAPSHOT system/.

kubectl apply -f system.yaml

kubectl apply -f traffic.yaml

kubectl get deployments

export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].nodePort}')
curl -H "Host:example.com" -I http://`minikube ip`:$INGRESS_PORT/system/properties

src/main/java/io/openliberty/guides/system/SystemResource.java -> "public static String APP_VERSION = "2.0-SNAPSHOT";"

mvn clean package

docker build -t system:2.0-SNAPSHOT system/.

kubectl set image deployment/system-deployment-green system-container=system:2.0-SNAPSHOT

curl -H "Host:test.example.com" -I http://`minikube ip`:$INGRESS_PORT/system/properties

curl -H "Host:example.com" -I http://`minikube ip`:$INGRESS_PORT/system/properties


traffic.yam -> "
spec:
  hosts:
  - "example.com"
  gateways:
  - sys-app-gateway
  http:
  - route:
    - destination:
        port:
          number: 9080
        host: system-service
        subset: blue
      weight: 0
    - destination:
        port:
          number: 9080
        host: system-service
        subset: green
      weight: 100
"

kubectl apply -f traffic.yaml

curl -H "Host:example.com" -I http://`minikube ip`:$INGRESS_PORT/system/properties

mvn test-compile
mvn failsafe:integration-test -Ddockerfile.skip=true -Dsystem.service.root="$(minikube ip):$INGRESS_PORT" -Dinventory.service.root="$(minikube ip):32000" -Dsystem.service.host="example.com"


#EKS Cluster
eksctl create cluster --name fleetman --nodes-min=3 --profile testaws --region eu-west-3
eksctl delete cluster --name fleetman --profile testaws --region eu-west-3
kubectl get pods -o wide


kubectl get svc -n monitoring

minikube addons enable metrics-server
minikube addons list
minikube addons enable dashboard

kubectl top pod
kubectl top node
kubectl describe node minikube
kubectl get hpa -o yaml

minikube addons enable ingress

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm show values prometheus-community/kube-prometheus-stack
helm upgrade monitoring prometheus-community/kube-prometheus-stack
helm upgrade monitoring prometheus-community/kube-prometheus-stack --set grafana.adminPassword=admin
helm upgrade monitoring prometheus-community/kube-prometheus-stack --values=values.yml
helm pull prometheus-community/kube-prometheus-stack --untar
helm upgrade monitoring ./kube-prometheus-stack/ --values=myvalues.yml
helm template monitoring ./kube-prometheus-stack/ --values=myvalues.yml > monitoring-stack.yml
kubectl apply -f monitoring-stack.yml
helm create fleetman-helm-chart
helm template ./fleetman-helm-chart/
helm template ./fleetman-helm-chart/ --set webapp.numberOfWebAppsReplicas=11

```