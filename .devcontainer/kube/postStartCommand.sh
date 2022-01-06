#!/usr/bin/bash

#Initial processing
echo ''
echo '--------------------------------------------'
echo ' Init'
echo '--------------------------------------------'

echo ''
echo '--------------------------------------------'
echo ' Cleanup Minikube'
echo '--------------------------------------------'
minikube delete 
minikube start --kubernetes-version=v1.21.0

echo ''
echo '--------------------------------------------'
echo ' Kubectl and Minikube version'
echo '--------------------------------------------'

kubectl version
minikube version
istioctl version

#End processing
echo ''
echo '--------------------------------------------'
echo ' Exit'
echo '--------------------------------------------'
echo 'The process ends.'
exit 0