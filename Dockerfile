FROM ubuntu:23.04
# Author: Justin Roysdon
# Date: 20230307
# Updated: 20240124
#

RUN apt-get update && apt-get install -y wget unzip curl git python3 python3-boto3 gh

# Make Link if Python3 install didn't do it
RUN if [ ! -f /usr/bin/python ]; then echo "Creating link for Python3..."; ln -s /usr/bin/python3 /usr/bin/python; fi

# Install gruntwork-installer, which is the preferred method for installing Gruntwork binaries and modules
RUN curl -LsS https://raw.githubusercontent.com/gruntwork-io/gruntwork-installer/v0.0.38/bootstrap-gruntwork-installer.sh | bash /dev/stdin --version v0.0.38 --no-sudo true

# Install fetch 
ARG FETCH_VERSION=0.4.5
RUN gruntwork-install --repo "https://github.com/gruntwork-io/fetch" --binary-name "fetch" --tag v0.4.5 --no-sudo true 

# Packer
ARG PACKER_VERSION=1.8.2
RUN wget -q https://releases.hashicorp.com/packer/1.8.2/packer_1.8.2_linux_amd64.zip &&   unzip packer_1.8.2_linux_amd64.zip &&   mv packer /usr/local/bin

# Terraform
ARG TERRAFORM_VERSION=1.2.4
RUN wget -q https://releases.hashicorp.com/terraform/1.2.4/terraform_1.2.4_linux_amd64.zip &&   unzip terraform_1.2.4_linux_amd64.zip &&   mv terraform /usr/local/bin

# Terragrunt
ARG TERRAGRUNT_VERSION=0.38.4
RUN gruntwork-install --repo "https://github.com/gruntwork-io/terragrunt" --binary-name "terragrunt" --tag v0.38.4 --no-sudo true

# AWS cli
RUN curl -s https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o aws_cli.zip &&   mkdir install_aws &&   cd install_aws &&   unzip ../aws_cli.zip &&   ./aws/install &&   cd .. &&   rm -rf install_aws

# aws-vault
ARG AWS_VAULT_VERSION=6.6.0
RUN fetch --repo="https://github.com/99designs/aws-vault" --tag="v6.6.0" --release-asset="aws-vault-linux-amd64" /usr/local/bin/
RUN mv /usr/local/bin/aws-vault-linux-amd64 /usr/local/bin/aws-vault
RUN chmod +x /usr/local/bin/aws-vault

# kubectl
ARG KUBECTL_VERSION=1.24.2
RUN curl -LO https://dl.k8s.io/release/v1.24.2/bin/linux/amd64/kubectl
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Golang
ARG GOLANG_VERSION=1.18.3
ARG GOPATH='/root/go'
RUN curl -L -s https://golang.org/dl/go1.18.3.linux-amd64.tar.gz -o go.tar.gz && rm -rf /usr/local/go && tar -C /usr/local -xzf go.tar.gz
RUN echo 'export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/usr/local/go/bin' >> /root/.profile
RUN echo 'export GOPATH=/root/go' >> /root/.profile
