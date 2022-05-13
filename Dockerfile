FROM ubuntu:focal

ARG IAC_NAME="iac"
ARG IAC_UID=1000
ARG IAC_GID=1000

ARG TERRAFORM_VERSION="1.0.8"
ARG TERRAGRUNT_VERSION="0.33.1"
ARG PACKER_VERSION="1.7.7"
ARG ANSIBLE_VERSION="2.9.23"
ARG AWS_CLI_VERSION="1.23.12"
ARG AWS_IAM_AUTHENTICATOR_VERSION="0.5.7"
ARG KUBECTL_VERSION="1.22.2"
ARG HELM_VERSION="3.7.1"
ARG SOPS_VERSION="3.7.2"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl git jq less openssh-client netcat neovim python3 python3-pip python3-netaddr unzip wget && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    terraform --version

RUN wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    mv terragrunt_linux_amd64 /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt && \
    terragrunt --version

RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin/ && \
    rm packer_${PACKER_VERSION}_linux_amd64.zip && \
    packer --version

RUN python3 -m pip install --no-cache-dir --upgrade pip

RUN python3 -m pip install --no-cache-dir \
        awscli==${AWS_CLI_VERSION} \
        ansible==${ANSIBLE_VERSION} && \
    aws --version && \
    ansible --version

RUN wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 && \
    mv aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 /usr/local/bin/aws-iam-authenticator && \
    chown root:root /usr/local/bin/aws-iam-authenticator && \
    chmod a+x /usr/local/bin/aws-iam-authenticator && \
    aws-iam-authenticator version

RUN wget https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/ && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client=true

RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    tar xvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -r helm-v${HELM_VERSION}-linux-amd64.tar.gz linux-amd64 && \
    helm version

RUN wget https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 && \
    mv sops-v${SOPS_VERSION}.linux.amd64 /usr/local/bin/sops && \
    chmod +x /usr/local/bin/sops && \
    sops -version

RUN groupadd -g ${IAC_GID} ${IAC_NAME}
RUN adduser ${IAC_NAME} --uid ${IAC_UID} --gid ${IAC_GID}
USER ${IAC_NAME}
WORKDIR /home/${IAC_NAME}
