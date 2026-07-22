#!/bin/bash

make clean && make mrproper

export KERNEL_ROOT="$(pwd)"
export PATH="$(readlink -f "${KERNEL_ROOT}/../clang-r450784d/bin"):${PATH}"

# Build options for the kernel
export BUILD_OPTIONS="
ARCH=arm64 \
LLVM=1 \
KCFLAGS=-w \
PLATFORM_VERSION=14 \
ANDROID_MAJOR_VERSION=14 \
KBUILD_BUILD_USER=ken \
KBUILD_BUILD_HOST=pkenti
"

build_kernel(){
    # Make default configuration.
    make ${BUILD_OPTIONS} -j$(nproc --all) exynos850-a13xx_defconfig
    
    # make ${BUILD_OPTIONS} -j$(nproc --all) menuconfig

    # Build the kernel
    make ${BUILD_OPTIONS} -j$(nproc --all) Image || exit 1

    # Copy the built kernel to the build directory
    if [ -e ${KERNEL_ROOT}/arch/arm64/boot/Image ]; then
    cp ${KERNEL_ROOT}/arch/arm64/boot/Image AnyKernel3

    echo "[+] Packaging kernel ..."
    cd AnyKernel3 && rm -f *.zip
    zip -r9 A135F-KVM.zip *
    echo "[-] Package done!"
    else
        exit 1
    fi
}
build_kernel
