FROM debian:bullseye-20220328

ENV CODE_SERVER_VER="3.12.0"
ENV CMD_APT_INSTALL="apt-get install -y --no-install-recommends"

RUN apt-get update
# Install useful tools.
## 'sudo' is required for the TCE installer.
RUN ${CMD_APT_INSTALL} apt-file clamav clamav-freshclam jq less man-db mlocate software-properties-common sudo vim
# Install compression tools.
RUN ${CMD_APT_INSTALL} gzip zip zstd
# Install network tools.
RUN ${CMD_APT_INSTALL} curl dnsutils iproute2 iputils-ping netcat nmap openssh-client openssl wget
# Install programming languages and tools.
RUN ${CMD_APT_INSTALL} git git-review gcc golang make openjdk-11-jre-headless python3 python3-pip python3-virtualenv virtualenv
## Install programming language linters.
RUN ${CMD_APT_INSTALL} golint python3-pylint-common shellcheck
### golangci-lint, a more advanced Go linter.
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/v1.43.0/install.sh | sh -s -- -b /usr/local/bin v1.43.0
# Install ZSH.
RUN ${CMD_APT_INSTALL} zsh
ENV RUNZSH=no
RUN curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
# Install code-server (Microsoft Visual Studio Code).
RUN wget https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb
RUN ${CMD_APT_INSTALL} ./code-server_${CODE_SERVER_VER}_amd64.deb
# Install Kubernetes tools.
## kubectl supports kube-apiserver versions that are 1 major version ahead and behind.
RUN wget https://dl.k8s.io/release/v1.19.16/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.19 && chmod +x /usr/local/bin/kubectl-1.19
RUN wget https://dl.k8s.io/release/v1.22.9/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.22 && chmod +x /usr/local/bin/kubectl-1.22
RUN ln -s /usr/local/bin/kubectl-1.22 /usr/local/bin/kubectl
RUN wget https://github.com/kubernetes-sigs/krew/releases/download/v0.4.2/krew-linux_amd64.tar.gz && tar -xvf krew-linux_amd64.tar.gz ./krew-linux_amd64 && mv ./krew-linux_amd64 /usr/local/bin/krew && chmod +x /usr/local/bin/krew
## Carvel/k14s tools for Kubernetes.
RUN wget -O- https://carvel.dev/install.sh | bash
## kpack-cli ('kp' command).
ENV KPACK_CLI_VER="0.5.0"
RUN wget https://github.com/vmware-tanzu/kpack-cli/releases/download/v${KPACK_CLI_VER}/kp-linux-${KPACK_CLI_VER} -O /usr/local/bin/kp && chmod +x /usr/local/bin/kp
## Helm for Kubernetes.
RUN wget -O- https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
## Knative client.
RUN wget https://github.com/knative/client/releases/download/knative-v1.1.0/kn-linux-amd64 -O /usr/local/bin/kn && chmod +x /usr/local/bin/kn
## Tanzu Community Edition (TCE).
ENV ALLOW_INSTALL_AS_ROOT=true TCE_VER=v0.11.0
RUN wget https://github.com/vmware-tanzu/community-edition/releases/download/${TCE_VER}/tce-linux-amd64-${TCE_VER}.tar.gz && tar -x -v -f tce-linux-amd64-${TCE_VER}.tar.gz && ./tce-linux-amd64-${TCE_VER}/install.sh
# Install the Docker Engine.
RUN ${CMD_APT_INSTALL} docker.io
# Cleanup.
RUN rm -rf ./code-server_${CODE_SERVER_VER}_amd64.deb ./krew.tar.gz ./tce-linux-amd64-${TCE_VER} ./tce-linux-amd64-${TCE_VER}.tar.gz
RUN apt-get clean all

VOLUME ["/mnt"]

# code-server.
EXPOSE 2003

CMD code-server --bind-addr 0.0.0.0:2003
