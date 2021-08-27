# container-ekultails-dev

`ekultails-dev` is a container image full of development tools that have been found to be useful for Luke Short (ekultails).

## Docker Hub

Docker Hub automatically builds and publishes a new container with the tag `:latest` after every commit to the `main` GitHub branch. Every tagged release in GitHub is also built as a container with the same tag.

## Usage

Build (optional):

```
$ docker build --tag ekultails/ekultails-dev:latest .
```

Run:

```
$ docker run -p 127.0.0.1:2003:2003 -v ${HOME}:/mnt -d --name ekultails-dev ekultails/ekultails-dev:latest
```

Run with Docker Engine support:

```
$ docker run -p 127.0.0.1:2003:2003 -v ${HOME}:/mnt -v /var/run/docker.sock:/var/run/docker.sock -d --name ekultails-dev ekultails/ekultails-dev:latest
```

Find the auto-generated `code-server` password:

```
$ docker exec ekultails-dev cat /root/.config/code-server/config.yaml | grep password:
```

## License

GPLv3
