#!/usr/bin/bash

#Initial processing
echo ''
echo '--------------------------------------------'
echo ' Init'
echo '--------------------------------------------'
#Settings / basic information
KUBECTL_SETTING_DEST=`realpath ~/.kube/`
echo 'Basic information'
echo "Working directory: `pwd`"
#Copy Kubectl config file
echo ''
echo '--------------------------------------------'
echo ' Copy Kubectl settings files'
echo '--------------------------------------------'
echo 'Copying will start.'
cp ./.devcontainer/kube/config ${KUBECTL_SETTING_DEST}
echo 'Copying is complete.'
ls -la ${KUBECTL_SETTING_DEST}

#End processing
echo ''
echo '--------------------------------------------'
echo ' Exit'
echo '--------------------------------------------'
echo 'The process ends.'
exit 0