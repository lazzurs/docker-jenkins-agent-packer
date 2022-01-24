FROM jenkins/inbound-agent:latest

ARG packer_version=1.7.9

# Switch to root
USER root

# Update system
RUN apt update && apt -y upgrade

# Add the ability to use PPAs
RUN apt -y install gnupg2

# Install Ansible
RUN apt -y install ansible

# Install Packer (jq for parsing manifest files)
RUN apt -y install wget unzip curl jq
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip
RUN unzip packer_${packer_version}_linux_amd64.zip -d /usr/local/bin/

# Install awscli
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
RUN unzip awscli-exe-linux-x86_64.zip
RUN ./aws/install

# Install AWS Session Manager plugin

RUN curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
RUN dpkg -i session-manager-plugin.deb

# Switch back to the jenkins user.

USER jenkins

