all: dist/x86_linux.so dist/aarch64_linux.so

llama.cpp: 
	git clone https://github.com/ggml-org/llama.cpp

dist:
	mkdir dist

dist/x86_linux.so: llama.cpp dist
	docker run --rm -v $(PWD)/llama.cpp:/app -w /app \
		ubuntu:22.04 bash -c \
		"apt-get update && \
		apt-get install -y cmake build-essential && \
		cmake -B build-x86 -DBUILD_SHARED_LIBS=ON && \
		cmake --build build-x86 --config Release -j8"
	cp llama.cpp/build/bin/libllama.so dist/x86_linux.so

dist/aarch64_linux.so: llama.cpp
	docker run --rm -v $(PWD)/llama.cpp:/app -w /app \
		ubuntu:22.04 bash -c \
		"apt-get update && \
		apt-get install -y cmake build-essential gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
		cmake -B build-arm64 \
			-DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc \
			-DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
			-DCMAKE_C_FLAGS=\"-march=armv8-a\" \
			-DCMAKE_CXX_FLAGS=\"-march=armv8-a\" \
			-DBUILD_SHARED_LIBS=ON &&\
		cmake  --build build-arm64 --config Release -j8"
	cp llama.cpp/build/bin/libllama.so dist/aarch64_linux.so
