FROM jenkins/inbound-agent:latest

ARG packer_version=1.8.5

# Switch to root
USER root

# Ensure system is up to date and install the following
# gnupg2: Add the ability to use PPAs
# pip: Install python packages
# rsync: To allow the use of ansible.posix.synchronise
# curl: Download packages
# unzip: Decompress packages
# jq: parse json files
RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y install --no-install-recommends gnupg2 pip rsync curl unzip jq sshpass \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV LC_ALL C.UTF-8

# Install latest Ansible + pywinrm + jinja2 using pip
RUN pip install --no-cache-dir ansible pywinrm jinja2

# Install Packer (jq for parsing manifest files)
RUN if [ "$(uname -m)" = "x86_64" ]; then curl "https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_amd64.zip" -o "packer.zip"; elif [ "$(uname -m)" = "aarch64" ]; then curl "https://releases.hashicorp.com/packer/${packer_version}/packer_${packer_version}_linux_arm64.zip" -o "packer.zip"; fi && unzip packer.zip -d /usr/local/bin/

# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install

# Install AWS Session Manager plugin
RUN if [ "$(uname -m)" = "x86_64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"; elif [ "$(uname -m)" = "aarch64" ]; then curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" -o "session-manager-plugin.deb"; fi && dpkg -i session-manager-plugin.deb

# Switch back to the jenkins user.
USER jenkins
