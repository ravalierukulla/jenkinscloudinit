#! /bin/bash

apt-get update
apt-get -y install docker

docker build -f jenkins-setup/Dockerfile -t jenkinsimage .

docker run -p 8080:8080 -p 5000:5000 -v 

docker run -d -v /var/run/docker.sock:/var/run/docker.sock \
              -v /path/to/your/jenkins/home:/var/jenkins_home \
              -p 8080:8080 \
              

