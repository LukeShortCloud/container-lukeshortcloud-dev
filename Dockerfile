FROM debian:bullseye-20210408-slim

ENV CODE_SERVER_VER="3.9.3"

RUN apt-get update
# Install useful tools.
RUN apt-get install -y apt-file clamav clamav-freshclam curl dnsutils jq mlocate nmap openssl software-properties-common vim wget
# Install compression tools.
RUN apt-get install -y gzip zip zstd
# Install programming languages and tools.
RUN apt-get install -y git git-review gcc golang make python3 python3-pip python3-virtualenv virtualenv
# Install code-server (Microsoft Visual Studio Code).
RUN wget https://github.com/cdr/code-server/releases/download/v${CODE_SERVER_VER}/code-server_${CODE_SERVER_VER}_amd64.deb
RUN apt-get install ./code-server_${CODE_SERVER_VER}_amd64.deb
RUN apt-get clean all

# code-server.
EXPOSE 2003

CMD code-server --bind-addr 0.0.0.0:2003
