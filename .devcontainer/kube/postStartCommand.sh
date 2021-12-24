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
nohup bash -c 'minikube start &' > /tmp/minikube.log 2>&1

echo ''
echo '--------------------------------------------'
echo ' Kubectl and Minikube version'
echo '--------------------------------------------'

kubectl version
minikube version

#End processing
echo ''
echo '--------------------------------------------'
echo ' Exit'
echo '--------------------------------------------'
echo 'The process ends.'
exit 0