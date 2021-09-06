FROM jenkins/inbound-agent:latest

ARG packer_version=1.7.4

# Switch to root
USER root

# Update system
RUN apt update && apt -y upgrade

# Add the ability to use PPAs
RUN apt -y install gnupg2

# Install Ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu focal main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6125E2A8C77F2818FB7BD15B93C4A3FD7BB9C367
RUN apt update
RUN apt -y install ansible-base

# Install Packer
RUN wget https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip
RUN unzip packer_${packer_version}_linux_amd64.zip -d /usr/local/bin/

# Switch back to the jenkins user.

USER jenkins

