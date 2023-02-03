# container-ekultails-dev

`ekultails-dev` is a container image full of development tools that have been found to be useful for Luke Short (ekultails).

## Docker Hub

Docker Hub automatically builds and publishes a new container with the tag `:latest` after every commit to the `main` GitHub branch. Every tagged release in GitHub is also built as a container with the same tag.

## Usage

Build (optional):

```
$ docker build --tag ekultails/ekultails-dev:latest .
```

Run as a container:

```
$ docker run -p 127.0.0.1:2003:2003 -v ${HOME}:/home_real -d --name ekultails-dev ekultails/ekultails-dev:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a container with Docker Engine support:

```
$ docker run -v ${HOME}:/home_real -v /var/run/docker.sock:/var/run/docker.sock --network host -d --name ekultails-dev ekultails/ekultails-dev:latest code-server --bind-addr 0.0.0.0:2003
```

Run as a Toolbox on Fedora:

```
$ toolbox create --image ekultails/ekultails-dev:latest
$ toolbox enter ekultails-dev-latest
```

## License

GPLv3
