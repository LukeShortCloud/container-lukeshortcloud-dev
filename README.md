# container-lukeshortcloud-dev

`dev` is a container image full of useful development tools.

## Usage

Build (optional):

```
$ [docker|podman] build --pull --tag lukeshortcloud/dev-[debian|fedora]:latest . -f Containerfile.[debian|fedora]
```

Run as a container:

```
$ [docker|podman] run -p 127.0.0.1:2003:2003 -v ${HOME}:/home_real -d --name dev-[debian|fedora] lukeshortcloud/dev-[debian|fedora]:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a container with Docker Engine support:

```
$ [docker|podman] run -v ${HOME}:/home_real -v /var/run/docker.sock:/var/run/docker.sock --network host -d --name dev-[debian|fedora] lukeshortcloud/dev-[debian|fedora]:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a Toolbox on Fedora Atomic Desktop:

```
$ toolbox create --image lukeshortcloud/dev-[debian|fedora]:latest
$ toolbox enter lukeshortcloud-dev-[debian|fedora]-latest
```

Run as a Distrobox on any Linux distribution:

```
$ distrobox create --image lukeshortcloud/dev-[debian|fedora]:latest --name dev-[debian|fedora]
$ distrobox enter dev-[debian|fedora]
```

## License

GPLv3
