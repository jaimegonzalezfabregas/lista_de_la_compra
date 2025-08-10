# Use latest stable channel SDK.
FROM dart:stable AS build

WORKDIR /app

# Copy app source code (except anything in .dockerignore) and AOT compile app.
COPY ./packages .
RUN ls -laRt
WORKDIR /app/lista_de_la_compra_server
RUN ls -laRt
RUN dart pub get
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server`
# and the pre-built AOT-runtime in the `/runtime/` directory of the base image.
FROM dart:stable

RUN apt-get update
RUN apt-get install -y libsqlite3-dev

# COPY --from=build /runtime/ /
COPY --from=build /app/lista_de_la_compra_server/bin/server /app/bin/

# Start server.
EXPOSE 4545
CMD ["/app/bin/server"]
