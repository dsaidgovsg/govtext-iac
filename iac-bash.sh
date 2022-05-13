#!/bin/bash
set -euo pipefail

umask 022

TERRAFORM_VERSION="1.0.8"
TERRAGRUNT_VERSION="0.33.1"
PACKER_VERSION="1.7.7"
ANSIBLE_VERSION="2.9.23"
AWS_CLI_VERSION="1.23.12"
AWS_IAM_AUTHENTICATOR_VERSION="0.5.7"
KUBECTL_VERSION="1.22.2"
HELM_VERSION="3.7.1"
SOPS_VERSION="3.7.2"

# Global install

sudo yum -y install ca-certificates curl git jq openssh-client nc neovim python3 python3-pip python3-netaddr unzip wget

wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    sudo mv packer /usr/local/bin/ && \
    rm packer_${PACKER_VERSION}_linux_amd64.zip && \
    packer --version

wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 && \
    sudo mv aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 /usr/local/bin/aws-iam-authenticator && \
    sudo chown root:root /usr/local/bin/aws-iam-authenticator && \
    sudo chmod a+x /usr/local/bin/aws-iam-authenticator && \
    aws-iam-authenticator version

wget https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    sudo mv kubectl /usr/local/bin/ && \
    sudo chown root:root /usr/local/bin/kubectl && \
    sudo chmod a+x /usr/local/bin/kubectl && \
    kubectl version --client=true

# wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
#     tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
#     sudo mv linux-amd64/helm /usr/local/bin/ && \
#     rm -r helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 && \
#     helm version

wget https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb && \
    sudo mv sops_${SOPS_VERSION}_amd64.deb /usr/local/bin/sops && \
    sudo chown root:root /usr/local/bin/kubectl && \
    sudo chmod a+x /usr/local/bin/kubectl && \
    sops -version

# User-only install

echo 'export PATH=${PATH}:${HOME}/.tfenv/bin:${HOME}/.tgenv/bin' >> "${HOME}/.bash_profile"
source "${HOME}/.bash_profile"

[ ! -d ~/.tfenv ] && git clone https://github.com/tfutils/tfenv.git ~/.tfenv
tfenv install ${TERRAFORM_VERSION}
tfenv use ${TERRAFORM_VERSION}
terraform --version

[ ! -d ~/.tgenv ] && git clone https://github.com/cunymatthieu/tgenv.git ~/.tgenv
tgenv install ${TERRAGRUNT_VERSION}
tgenv use ${TERRAGRUNT_VERSION}
terragrunt --version

python3 -m pip install --upgrade pip

python3 -m pip install --user --no-cache-dir \
        awscli==${AWS_CLI_VERSION} \
        ansible==${ANSIBLE_VERSION} && \
    aws --version && \
    ansible --version
