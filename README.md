# container-ekultails-dev

`ekultails-dev` is a container image full of development tools that have been found to be useful for Luke Short (ekultails).

## Usage

Build (optional):

```
$ [docker|podman] build --pull --tag ekultails/ekultails-dev:latest . -f Containerfile.[debian|fedora]
```

Run as a container:

```
$ [docker|podman] run -p 127.0.0.1:2003:2003 -v ${HOME}:/home_real -d --name ekultails-dev ekultails/ekultails-dev:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a container with Docker Engine support:

```
$ [docker|podman] run -v ${HOME}:/home_real -v /var/run/docker.sock:/var/run/docker.sock --network host -d --name ekultails-dev ekultails/ekultails-dev:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a Toolbox on Fedora:

```
$ toolbox create --image ekultails/ekultails-dev:latest
$ toolbox enter ekultails-dev-latest
```

Run as a Distrobox on any Linux distribution:

```
$ distrobox create --image ekultails/ekultails-dev:latest --name ekultails-dev
$ distrobox enter ekultails-dev
```

## License

GPLv3
