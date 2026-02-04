

build-container:
	./flutterw.sh --build

clean-container:
	./docker-exec.sh --cleancache

pub-get-container: build-container
	./flutterw.sh pub get

build-runner-container: pub-get-container
	./flutterw.sh --exec dart run build_runner build

run-linux-debug-container: build-runner-container
	./flutterw.sh run -d linux

build-apk-container: build-runner-container
	./flutterw.sh build --release apk