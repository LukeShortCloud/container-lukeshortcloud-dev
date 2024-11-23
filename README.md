# container-lukeshortcloud-dev

`dev` is a container image full of useful development tools. An Arch Linux, Debian, Fedora, and Ubuntu container are maintained.

## Container Registry

For each tagged release on GitHub, a GitHub Actions CI/CD pipeline tests each container image build. It then pushes them to the Quay.io container registry using the same tag and also a `latest` tag.

- quay.io/lukeshortcloud/dev-archlinux:latest
- quay.io/lukeshortcloud/dev-debian:latest
- quay.io/lukeshortcloud/dev-fedora:latest
- quay.io/lukeshortcloud/dev-ubuntu:latest

## Usage

Build (optional):

```
$ [docker|podman] build --pull --tag lukeshortcloud/dev-[archlinux|debian|fedora]:latest . -f Containerfile.[archlinux|debian|fedora]
```

-  If rebuilding the Arch Linux container, the `--no-cache` argument may be needed to deal with the rolling releases.

Full support is also provided for an Ubuntu build:

```
$ cp Containerfile.debian Containerfile.ubuntu
$ sed -i s'/^FROM debian:.*/FROM ubuntu:24.04/'g Containerfile.ubuntu
$ [docker|podman] build --pull --tag lukeshortcloud/dev-ubuntu:latest . -f Containerfile.ubuntu
```

Run as a container:

```
$ [docker|podman] run -p 127.0.0.1:2003:2003 -v ${HOME}:/home_real -d --name dev-[archlinux|debian|fedora|ubuntu] lukeshortcloud/dev-[archlinux|debian|fedora|ubuntu]:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a container with Docker Engine support:

```
$ [docker|podman] run -v ${HOME}:/home_real -v /var/run/docker.sock:/var/run/docker.sock --network host -d --name dev-[archlinux|debian|fedora|ubuntu] lukeshortcloud/dev-[archlinux|debian|fedora|ubuntu]:latest code-server --bind-addr 0.0.0.0:2003
$ [docker|podman] exec dev-[archlinux|debian|fedora|ubuntu] cat /root/.config/code-server/config.yaml | grep password:
```

Run as a Toolbox on Fedora Atomic Desktop:

```
$ toolbox create --image lukeshortcloud/dev-[archlinux|debian|fedora|ubuntu]:latest
$ toolbox enter lukeshortcloud-dev-[archlinux|debian|fedora|ubuntu]-latest
```

Run as a Distrobox on any Linux distribution:

```
$ distrobox create --init --image lukeshortcloud/dev-[archlinux|debian|fedora|ubuntu]:latest --name dev-[archlinux|debian|fedora|ubuntu]
$ distrobox enter dev-[archlinux|debian|fedora|ubuntu]
```

If using Distrobox or Toolbox, optionally inside the container, run the `code-server` service and then find the password.

```
$ tmux new-session -d -s code-server 'code-server --bind-addr 0.0.0.0:2003'
$ cat ~/.config/code-server/config.yaml | grep password:
```

## License

GPLv3
