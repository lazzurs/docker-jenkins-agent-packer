FROM jenkins/inbound-agent:latest

ARG packer_version=1.8.0

# Switch to root
USER root

# Update system
RUN apt update && apt -y upgrade

# Add the ability to use PPAs
RUN apt -y install gnupg2

# Install Ansible
RUN apt -y install ansible

# Install Rsync to allow use of ansible.posix.synchronise
RUN apt -y install rsync

# Install Packer (jq for parsing manifest files)
RUN apt -y install wget unzip curl jq
RUN if [ $(uname -m) = "x86_64" ]; then curl "https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip" -o "packer.zip"; elif [ $(uname -m) = "aarch64" ]; then curl "https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_arm64.zip" -o "packer.zip"; fi
RUN unzip packer.zip -d /usr/local/bin/

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install

# Install AWS Session Manager plugin

RUN if [ $(uname -m) = "x86_64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"; elif [ $(uname -m) = "aarch64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "session-manager-plugin.deb"; fi
RUN dpkg -i session-manager-plugin.deb

# Switch back to the jenkins user.

USER jenkins

