# container-lukeshortcloud-dev

`dev` is a container image full of useful development tools. Both a Debian and Fedora container are maintained.

## Container Registry

Quay.io automatically builds and publishes a new container with the tag `:latest` after every commit to the `main` GitHub branch. Every tagged release in GitHub is also built as a container with the same tag.

- quay.io/lukeshortcloud/dev-debian:latest
- quay.io/lukeshortcloud/dev-fedora:latest

## Usage

Build (optional):

```
$ [docker|podman] build --pull --tag lukeshortcloud/dev-[debian|fedora]:latest . -f Containerfile.[debian|fedora]
```

Experimental support is provided for Ubuntu builds:

```
$ sed -i s'/^FROM debian:.*/FROM ubuntu:24.04/'g Containerfile.debian
$ [docker|podman] build --pull --tag lukeshortcloud/dev-ubuntu:latest . -f Containerfile.debian
```

Run as a container:

```
$ [docker|podman] run -p 127.0.0.1:2003:2003 -v ${HOME}:/home_real -d --name dev-[debian|fedora] lukeshortcloud/dev-[debian|fedora]:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a container with Docker Engine support:

```
$ [docker|podman] run -v ${HOME}:/home_real -v /var/run/docker.sock:/var/run/docker.sock --network host -d --name dev-[debian|fedora] lukeshortcloud/dev-[debian|fedora]:latest code-server --bind-addr 0.0.0.0:2003
$ podman exec dev-[debian|fedora] cat /root/.config/code-server/config.yaml | grep password:
```

Run as a Toolbox on Fedora Atomic Desktop:

```
$ toolbox create --image lukeshortcloud/dev-[debian|fedora]:latest
$ toolbox enter lukeshortcloud-dev-[debian|fedora]-latest
```

Run as a Distrobox on any Linux distribution:

```
$ distrobox create --init --image lukeshortcloud/dev-[debian|fedora]:latest --name dev-[debian|fedora]
$ distrobox enter dev-[debian|fedora]
```

If using Distrobox or Toolbox, optionally inside the container, run the `code-server` service and then find the password.

```
$ tmux new-session -d -s code-server 'code-server --bind-addr 0.0.0.0:2003'
$ cat ~/.config/code-server/config.yaml | grep password:
```

## License

GPLv3
