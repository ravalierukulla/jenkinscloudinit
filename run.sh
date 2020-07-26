#! /bin/bash
set -exuo pipefail

# Install Docker
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-key fingerprint 0EBFCD88

add-apt-repository \
"deb [arch=amd64] https://download.docker.com/linux/debian \
$(lsb_release -cs) \
stable"

apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io

# Run Jenkins image
docker build -t jenkinsimage .
JENKINS_PASS=$(az keyvault secret show --vault-name "ptc-cicd-dev-kvt" --name jenkins-pass --query 'value' -o tsv)
docker run -d \
-e JENKINS_PASS="${JENKINS_PASS}" \
-v /var/run/docker.sock:/var/run/docker.sock -p 8080:8080 jenkinsimage:latest
