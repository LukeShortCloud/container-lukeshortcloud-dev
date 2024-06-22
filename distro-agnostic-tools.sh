#!/bin/bash

# Enable (1) exit on errors and (2) debug logging.
set -e -x

# Azure CLI ("az" command).
curl -sL https://aka.ms/InstallAzureCLIDeb | bash
az --version

# code-server (Microsoft Visual Studio Code web server).
curl -fsSL https://code-server.dev/install.sh | sh
code-server --version

# golangci-lint.
export GOLANGCI_LINT_VER="1.59.1"
curl -sSfL "https://raw.githubusercontent.com/golangci/golangci-lint/v${GOLANGCI_LINT_VER}/install.sh" | sh -s -- -b /usr/local/bin "v${GOLANGCI_LINT_VER}"
golangci-lint --version

# HashiCorp Vault.
export VAULT_VER="1.17.0"
wget "https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip"
unzip vault_${VAULT_VER}_linux_amd64.zip
sudo mv ./vault /usr/local/bin/
vault --version

# Kubernetes tools.
## Autocompletion for 'kubectl'. Requires 'bash-completion' to be installed.
## https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
echo 'source /usr/share/bash-completion/bash_completion' >> /etc/bashrc
echo 'source <(kubectl completion bash)' >> /etc/bashrc
## Carvel/k14s.
wget -O- https://carvel.dev/install.sh | bash
ytt --version
## Helm.
wget -O- https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm version
## kind.
export KIND_VER="v0.20.0"
wget https://kind.sigs.k8s.io/dl/${KIND_VER}/kind-linux-amd64 -O /usr/local/bin/kind
chmod +x /usr/local/bin/kind
kind version
## kubectl.
## This supports kube-apiserver versions that are 1 major version ahead and behind.
wget https://dl.k8s.io/release/v1.22.17/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.22 && chmod +x /usr/local/bin/kubectl-1.22
wget https://dl.k8s.io/release/v1.25.14/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.25 && chmod +x /usr/local/bin/kubectl-1.25
wget https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.28 && chmod +x /usr/local/bin/kubectl-1.28
ln -s /usr/local/bin/kubectl-1.25 /usr/local/bin/kubectl
kubectl version --client
## Knative client.
export KNATIVE_CLIENT_VER="1.11.0"
wget "https://github.com/knative/client/releases/download/knative-v${KNATIVE_CLIENT_VER}/kn-linux-amd64" -O /usr/local/bin/kn
chmod +x /usr/local/bin/kn
kn version
## kpack-cli ('kp' command).
export KPACK_CLI_VER="0.12.0"
wget https://github.com/buildpacks-community/kpack-cli/releases/download/v${KPACK_CLI_VER}/kp-linux-amd64-${KPACK_CLI_VER} -O /usr/local/bin/kp
chmod +x /usr/local/bin/kp
kp version
## Krew.
export KREW_VER="0.4.4"
wget "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VER}/krew-linux_amd64.tar.gz"
tar -xvf krew-linux_amd64.tar.gz ./krew-linux_amd64
mv ./krew-linux_amd64 /usr/local/bin/krew
chmod +x /usr/local/bin/krew
rm -f ./krew-linux_amd64.tar.gz
krew version
## Kustomize.
## This will install the latest version into the current working directory.
## https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/
cd /usr/local/bin/ && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
kustomize version

# Oh My Zsh.
export RUNZSH=no
curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash

# Rust.
## Configure Rust to be installed globally.
export CARGO_HOME="/usr/local/cargo"
export RUSTUP_HOME="/usr/local/rustup"
echo 'PATH="/usr/local/cargo/bin:${PATH}"' > /etc/profile.d/rust.sh && chmod +x /etc/profile.d/rust.sh
curl -sSf https://sh.rustup.rs | bash -s -- -y
/usr/local/cargo/bin/cargo version

# yq for querying JSON, XML, and YAML.
export YQ_VER="v4.35.2"
wget https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_amd64 -O /usr/local/bin/yq
chmod +x /usr/local/bin/yq
yq --version
