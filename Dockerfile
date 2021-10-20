FROM jenkins/inbound-agent:latest

ARG packer_version=1.7.7

# Switch to root
USER root

# Update system
RUN apt update && apt -y upgrade

# Add the ability to use PPAs
RUN apt -y install gnupg2

# Install Ansible
RUN apt -y install ansible

# Install Packer
RUN apt -y install wget unzip curl
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip
RUN unzip packer_${packer_version}_linux_amd64.zip -d /usr/local/bin/

# Install awscli
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip awscli-exe-linux-x86_64.zip
RUN ./aws/install

# Switch back to the jenkins user.

USER jenkins

