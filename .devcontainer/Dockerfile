# Note: You can use any Debian/Ubuntu based image you want. 
FROM mcr.microsoft.com/vscode/devcontainers/base:0-bullseye

# Enable new "BUILDKIT" mode for Docker CLI
ENV DOCKER_BUILDKIT=1

# Options
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="false"
ARG USE_MOBY="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG JAVA_HOME="/opt/java/openjdk"
ARG MAVEN_VERSION=3.8.4
ARG MAVEN_SHA=a9b2d825eacf2e771ed5d6b0e01398589ac1bfa4171f36154d1b5787879605507802f699da6f7cfc80732a5282fd31b28e4cd6052338cbef0fa1358b48a5e3c8
ARG KUBECTLVERSION="1.21"
ARG MINIKUBEVERSION="1.24.0"
ARG EKSCTL="0.77.0"
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && /bin/bash /tmp/library-scripts/docker-in-docker-debian.sh "true" "${USERNAME}" "${USE_MOBY}" \ 
    && /bin/bash /tmp/library-scripts/kubectl-helm-debian.sh "${KUBECTLVERSION}" "latest" "${MINIKUBEVERSION}" \
    && mkdir -p /home/${USERNAME}/.minikube \
    && chown ${USERNAME} /home/${USERNAME}/.minikube \
    && mkdir -p /home/${USERNAME}/.kube \
    && chown ${USERNAME} /home/${USERNAME}/.kube \
    && export KUBECTLVERSION=${KUBECTLVERSION} && export MINIKUBEVERSION=${MINIKUBEVERSION} \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

# Install Kubernetes tools

RUN echo "installing kubernetes tools..." \
    && cd /tmp && curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.12.1 TARGET_ARCH=x86_64 sh - \
    && cp -f /tmp/istio-1.12.1/bin/istioctl /usr/local/bin/istioctl \
    && chmod 0755 /usr/local/bin/istioctl

RUN echo "building dev tools..." \
    # Install OpenJDK11
    && DEBIAN_FRONTEND=noninteractive \
    && apt-get -y update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get install -y openjdk-11-jre openjdk-11-jdk \
    && mkdir -p "$JAVA_HOME" && xargs ln -s "/usr/lib/jvm/java-11-openjdk-amd64" "$JAVA_HOME" \
    && java -version \
    && echo "JAVA_HOME=$JAVA_HOME" >> /etc/environment \
    && echo "$JAVA_HOME" \
    # Install Maven
    && mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && echo "${MAVEN_SHA} /tmp/apache-maven.tar.gz" | sha512sum -c - \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && rm -f /tmp/apache-maven.tar.gz \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn \
    # Maven User Settings
    && mkdir /home/${USERNAME}/.m2 \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.m2 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

RUN echo "installing EKS tools..." \
    && curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp     \
    && mv /tmp/eksctl /usr/local/bin \
    && eksctl version

RUN echo "installing AWS client..." \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ls . \
    && sudo ./aws/install \
    && aws --version

VOLUME [ "/var/lib/docker" ]

# Setting the ENTRYPOINT to docker-init.sh will start up the Docker Engine 
# inside the container "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
