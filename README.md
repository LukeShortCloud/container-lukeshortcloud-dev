# container-ekultails-dev

A container image full of development tools that have been found to be useful for Luke Short (ekultails).

## Usage

Build (optional):

```
$ docker build --tag ekultails-dev:0.1.0 .
```

Run:

```
$ docker run -p 127.0.0.1:2003:2003 -d --name ekultails-dev ekultails-dev:0.1.0
```

Find the auto-generated `code-server` password:

```
$ docker exec ekultails-dev cat /root/.config/code-server/config.yaml | grep password:
```

## License

GPLv3
