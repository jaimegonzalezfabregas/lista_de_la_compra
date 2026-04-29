all: dist/x86_linux.so dist/aarch64_linux.so

llama.cpp: 
	git clone https://github.com/ggml-org/llama.cpp

dist:
	mkdir dist

toolchains/x86/is_ready.flag:
	docker build -t jaimegf_x86_toolchain toolchains/x86
	echo "This file tells the build system that the x86 docker is built" > toolchains/x86/is_ready.flag

toolchains/aarch64/is_ready.flag:
	docker build -t jaimegf_aarch64_toolchain toolchains/aarch64
	echo "This file tells the build system that the aarch64 docker is built" > toolchains/aarch64/is_ready.flag


common_parameters =
			-DBUILD_SHARED_LIBS=ON \
			-DCMAKE_EXE_LINKER_FLAGS=\"-static -g\" \
			-DCMAKE_BUILD_TYPE=Release \
			-DBUILD_SHARED_LIBS=ON \
			-DCMAKE_INSTALL_RPATH=@loader_path \
			-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
			-DCMAKE_INSTALL_NAME_DIR=@rpath \
			-DGGML_BLAS=OFF \
			-DGGML_OPENMP=OFF \
			-DLLAMA_BUILD_TESTS=OFF \
			-DLLAMA_BUILD_EXAMPLES=OFF \
			-DLLAMA_CURL=OFF 

dist/x86_linux.so: llama.cpp dist toolchains/x86/is_ready.flag
	docker run --rm -v $(PWD)/llama.cpp:/app -w /app \
		jaimegf_x86_toolchain bash -c \
		"rm -rf build-x86 && \
		cmake -B build-x86 \
			$(common_parameters) &&\
		cmake --build build-x86 --config Release -j7"
	cp llama.cpp/build-x86/bin/libllama.so dist/x86_linux.so

# valid DGGML_CPU_ARM_ARCH are: armv8-a armv8.1-a armv8.2-a armv8.3-a armv8.4-a armv8.5-a armv8.6-a armv8-r
# parameter list source https://learn.arm.com/learning-paths/mobile-graphics-and-gaming/performance_llama_cpp_sme2/build_llama_cpp/
dist/aarch64_linux.so: llama.cpp dist toolchains/aarch64/is_ready.flag
	docker run --rm -v $(PWD)/llama.cpp:/app -w /app \
		jaimegf_aarch64_toolchain bash -c \
		"rm -rf build-arm64 && \
		cmake -B build-arm64 \
			-DCMAKE_SYSTEM_NAME=Linux \
			-DCMAKE_SYSTEM_PROCESSOR=arm \
			-DCMAKE_C_COMPILER=/usr/bin/aarch64-linux-gnu-gcc \
			-DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
			-DLLAMA_NATIVE=OFF \
			-DCMAKE_C_FLAGS=\" -march=armv8-a -g\" \
			-DCMAKE_CXX_FLAGS=\" -march=armv8-a -g\" \
			-DGGML_CPU_KLEIDIAI=ON \
			$(common_parameters) && \
		cmake --build build-arm64 --config Release -j7"
	cp llama.cpp/build-arm64/bin/libllama.so dist/aarch64_linux.so
