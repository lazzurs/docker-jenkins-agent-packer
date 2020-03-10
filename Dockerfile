FROM jenkins/jnlp-slave:latest

ARG packer_version=1.5.4

USER root
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip
RUN unzip packer_${packer_version}_linux_amd64.zip -d /usr/local/bin/

USER jenkins

