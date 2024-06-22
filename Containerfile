FROM debian:11.7

ENV CMD_APT_INSTALL="apt-get install -y --no-install-recommends"

RUN apt-get update
# Install useful tools.
## 'ca-certificates' is not installed by default in Debian container images.
## https://stackoverflow.com/questions/66473954/no-installed-certificates-on-debianbuster-docker-image
## 'sudo' is required for the container to work as a Toolbox.
RUN ${CMD_APT_INSTALL} apt-file ca-certificates clamav clamav-freshclam jq less man-db mlocate software-properties-common rsync sudo vim
# Install compression tools.
RUN ${CMD_APT_INSTALL} gzip p7zip-full unzip zip zstd
# Install network tools.
RUN ${CMD_APT_INSTALL} curl dnsutils iproute2 iputils-ping netcat nmap openssh-client openssl wget
# Install programming languages and tools.
RUN ${CMD_APT_INSTALL} build-essential git git-review gcc golang make openjdk-17-jdk python3 python3-pip python3-virtualenv virtualenv
## Rust.
### Configure Rust to be installed globally.
ENV CARGO_HOME="/usr/local/cargo"
ENV RUSTUP_HOME="/usr/local/rustup"
RUN echo 'PATH="/usr/local/cargo/bin:${PATH}"' > /etc/profile.d/rust.sh && chmod +x /etc/profile.d/rust.sh
RUN curl -sSf https://sh.rustup.rs | bash -s -- -y
## GitHub CLI ('gh' command).
## https://github.com/cli/cli/blob/trunk/docs/install_linux.md
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" >> /etc/apt/sources.list.d/github-cli.list && apt-get update && ${CMD_APT_INSTALL} gh
## Install programming language linters.
RUN ${CMD_APT_INSTALL} golint python3-pylint-common shellcheck
### golangci-lint, a more advanced Go linter.
ENV GOLANGCI_LINT_VER="1.54.2"
RUN curl -sSfL "https://raw.githubusercontent.com/golangci/golangci-lint/v${GOLANGCI_LINT_VER}/install.sh" | sh -s -- -b /usr/local/bin "v${GOLANGCI_LINT_VER}"
# Install ZSH.
RUN ${CMD_APT_INSTALL} zsh
ENV RUNZSH=no
RUN curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
# Install code-server (Microsoft Visual Studio Code).
ENV CODE_SERVER_VER="4.17.0"
RUN wget https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb
RUN ${CMD_APT_INSTALL} ./code-server_${CODE_SERVER_VER}_amd64.deb
# Install Kubernetes tools.
## kubectl supports kube-apiserver versions that are 1 major version ahead and behind.
RUN wget https://dl.k8s.io/release/v1.22.17/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.22 && chmod +x /usr/local/bin/kubectl-1.22
RUN wget https://dl.k8s.io/release/v1.25.14/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.25 && chmod +x /usr/local/bin/kubectl-1.25
RUN wget https://dl.k8s.io/release/v1.28.2/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.28 && chmod +x /usr/local/bin/kubectl-1.28
RUN ln -s /usr/local/bin/kubectl-1.25 /usr/local/bin/kubectl
### Autocompletion for 'kubectl'.
### https://kubernetes.io/docs/tasks/tools/included/optional-kubectl-configs-bash-linux/
RUN ${CMD_APT_INSTALL} bash-completion
RUN echo 'source /usr/share/bash-completion/bash_completion' >> /etc/bashrc
RUN echo 'source <(kubectl completion bash)' >> /etc/bashrc
### Krew.
ENV KREW_VER="0.4.4"
RUN wget "https://github.com/kubernetes-sigs/krew/releases/download/v${KREW_VER}/krew-linux_amd64.tar.gz" && tar -xvf krew-linux_amd64.tar.gz ./krew-linux_amd64 && mv ./krew-linux_amd64 /usr/local/bin/krew && chmod +x /usr/local/bin/krew
### Kustomize. This will install the latest version into the current working directory.
### https://kubectl.docs.kubernetes.io/installation/kustomize/binaries/
RUN cd /usr/local/bin/ && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
## Carvel/k14s tools for Kubernetes.
RUN wget -O- https://carvel.dev/install.sh | bash
## kpack-cli ('kp' command).
ENV KPACK_CLI_VER="0.12.0"
RUN wget https://github.com/buildpacks-community/kpack-cli/releases/download/v${KPACK_CLI_VER}/kp-linux-amd64-${KPACK_CLI_VER} -O /usr/local/bin/kp && chmod +x /usr/local/bin/kp
## Helm for Kubernetes.
RUN wget -O- https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
## Knative client.
ENV KNATIVE_CLIENT_VER="1.11.0"
RUN wget "https://github.com/knative/client/releases/download/knative-v${KNATIVE_CLIENT_VER}/kn-linux-amd64" -O /usr/local/bin/kn && chmod +x /usr/local/bin/kn
## kind.
ENV KIND_VER="v0.20.0"
RUN wget https://kind.sigs.k8s.io/dl/${KIND_VER}/kind-linux-amd64 -O /usr/local/bin/kind && chmod +x /usr/local/bin/kind
# Install the Docker Engine.
RUN ${CMD_APT_INSTALL} docker.io
# Install yq (JSON, XML, and YAML query).
ENV YQ_VER="v4.35.2"
RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VER}/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq
# Azure CLI ("az" command).
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
# Sphinx for Root Pages documentation development.
RUN ${CMD_APT_INSTALL} python3-sphinx python3-sphinx-rtd-theme
# HashiCorp Vault.
ENV VAULT_VER="1.15.0"
RUN wget "https://releases.hashicorp.com/vault/${VAULT_VER}/vault_${VAULT_VER}_linux_amd64.zip" && unzip vault_${VAULT_VER}_linux_amd64.zip && sudo mv ./vault /usr/local/bin/ && vault --version
# Distrobox support.
## distrobox-init installs these packages. We pre-install them now so the container can start instantly.
## https://github.com/89luca89/distrobox/blob/1.5.0.2/distrobox-init#L419
RUN ${CMD_APT_INSTALL} apt-utils bash bash-completion bc bzip2 curl dialog diffutils findutils gnupg gnupg2 gpgsm hostname iproute2 iputils-ping keyutils less libcap2-bin libegl1-mesa libgl1-mesa-glx libkrb5-3 libnss-mdns libnss-myhostname libvte-2.9*-common libvte-common libvulkan1 locales lsof man-db manpages mesa-vulkan-drivers mtr ncurses-base openssh-client passwd pigz pinentry-curses procps rsync sudo tcpdump time traceroute tree tzdata unzip util-linux wget xauth xz-utils zip
# Cleanup.
RUN rm -rf ./code-server_${CODE_SERVER_VER}_amd64.deb ./krew-linux_amd64.tar.gz
RUN apt-get clean all

VOLUME ["/home_real"]

# code-server.
EXPOSE 2003
#CMD code-server --bind-addr 0.0.0.0:2003
# Find the auto-generated `code-server` password:
# $ podman exec ekultails-dev cat /root/.config/code-server/config.yaml | grep password:

# Toolbox support.
ENV NAME=ekultails-dev VERSION=rolling
LABEL com.github.containers.toolbox="true" \
  name="$NAME" \
  version="$VERSION"
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
CMD ["/bin/bash"]
