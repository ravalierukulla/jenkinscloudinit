FROM jenkins/jenkins:lts

ENV TERRAFORM_VERSION 0.12.28

USER root

# Install docker
RUN apt-get update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88

RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"

RUN apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io

RUN curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Install Ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
    apt update && \
    apt -y install ansible

# Install terraform
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Azure-CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Jenkins
RUN usermod -a -G docker jenkins

USER jenkins
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
COPY jenkins-setup/plugins.txt /usr/share/jenkins/ref/


COPY jenkins-setup/init-user.groovy /usr/share/jenkins/ref/init.groovy.d/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt