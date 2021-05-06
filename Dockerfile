FROM debian:bullseye-20210408

ENV CODE_SERVER_VER="3.9.3"

RUN apt-get update
# Install useful tools.
RUN apt-get install -y apt-file clamav clamav-freshclam curl dnsutils jq man-db mlocate nmap openssl software-properties-common vim wget
# Install compression tools.
RUN apt-get install -y gzip zip zstd
# Install programming languages and tools.
RUN apt-get install -y git git-review gcc golang make openjdk-11-jre-headless python3 python3-pip python3-virtualenv virtualenv
# Install code-server (Microsoft Visual Studio Code).
RUN wget https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb
RUN apt-get install ./code-server_${CODE_SERVER_VER}_amd64.deb
# Install Kubernetes tools.
## kubectl supports kube-apiserver versions that are 1 major version ahead and behind.
RUN wget https://dl.k8s.io/release/v1.19.10/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl-1.19 && chmod +x /usr/local/bin/kubectl-1.19
RUN ln -s /usr/local/bin/kubectl-1.19 /usr/local/bin/kubectl
RUN wget https://github.com/kubernetes-sigs/krew/releases/download/v0.4.1/krew.tar.gz && tar -xvf krew.tar.gz ./krew-linux_amd64 && mv ./krew-linux_amd64 /usr/local/bin/krew && chmod +x /usr/local/bin/krew
## Carvel/k14s tools for Kubernetes.
RUN wget -O- https://carvel.dev/install.sh | bash
## Helm for Kubernetes.
RUN wget -O- https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
# Cleanup.
RUN rm -f ./code-server_${CODE_SERVER_VER}_amd64.deb ./krew.tar.gz
RUN apt-get clean all

VOLUME ["/mnt"]

# code-server.
EXPOSE 2003

CMD code-server --bind-addr 0.0.0.0:2003
