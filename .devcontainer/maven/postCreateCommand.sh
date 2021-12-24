#!/usr/bin/bash

#Initial processing
echo ''
echo '--------------------------------------------'
echo ' Init'
echo '--------------------------------------------'
#Settings / basic information
MAVEN_SETTING_DEST=`realpath ~/.m2/`
echo 'Basic information'
echo "Working directory: `pwd`"
echo "maven: `mvn --version`"

#Copy Maven config file
echo ''
echo '--------------------------------------------'
echo ' Copy Maven settings files'
echo '--------------------------------------------'
echo 'Copying will start.'
cp ./.devcontainer/maven/settings.xml ./.devcontainer/maven/settings-security.xml ${MAVEN_SETTING_DEST}
echo 'Copying is complete.'
ls -la ${MAVEN_SETTING_DEST}

#End processing
echo ''
echo '--------------------------------------------'
echo ' Exit'
echo '--------------------------------------------'
echo 'The process ends.'
exit 0