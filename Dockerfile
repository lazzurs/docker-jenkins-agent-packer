ARG ARCH=
FROM jenkins/inbound-agent:latest

ARG packer_version=1.7.9

# Switch to root
USER root

# Testing arch output
RUN echo ${ARCH}
RUN uname -m

# Update system
RUN apt update && apt -y upgrade

# Add the ability to use PPAs
RUN apt -y install gnupg2

# Install Ansible
RUN apt -y install ansible

# Install Packer (jq for parsing manifest files)
RUN apt -y install wget unzip curl jq
RUN curl https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_${ARCH}.zip -o packer.zip
RUN unzip packer.zip -d /usr/local/bin/

# Install awscli
RUN if [ ${ARCH} = "amd64" ]; then curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; elif [ ${ARCH} = "arm64" ]; then curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; fi
RUN unzip awscliv2.zip
RUN ./aws/install

# Install AWS Session Manager plugin

RUN if [ ${ARCH} = "amd64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"; elif [ ${ARCH} = "arm64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "session-manager-plugin.deb"; fi
RUN dpkg -i session-manager-plugin.deb

# Switch back to the jenkins user.

USER jenkins

