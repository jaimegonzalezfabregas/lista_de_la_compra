A server app for the [Shopping List application](https://f-droid.org/en/packages/com.jaimegonzalezfabregas.shoppinglist/),
configured to enable running with [Docker](https://www.docker.com/).

# Running the sample

Get the source code from the [git repository](https://github.com/jaimegonzalezfabregas/lista_de_la_compra). This package is in the `packages/lista_de_la_compra_server` directory

```
$ git clonehttps://github.com/jaimegonzalezfabregas/lista_de_la_compra.git
```


## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ cd $REPODIR/packages/lista_de_la_compra_server
$ dart run bin/server.dart
```

Alternatively, you can run the server with `$REPODIR/run-server.sh`

The server will listen on port `4545`.

## Running with Docker

There is a `Dockerfile` that builds and runs the server. 

```
cd $REPODIR
docker build . --progress=plain -t lista_de_la_compra_server
sudo docker run -it -p 4545:4545 lista_de_la_compra_server
```

Alternatively, you can build and run the docker image with `$REPODIR/run-server-on-docker.sh`
