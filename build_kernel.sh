#!/bin/bash

DIR="$(readlink -f .)"
PARENT_DIR="$(readlink -f "${DIR}/..")"

export CROSS_COMPILE="$PARENT_DIR/clang-r450784d/bin/aarch64-linux-gnu-"
export CC="$PARENT_DIR/clang-r450784d/bin/clang"
export PATH="$PARENT_DIR/clang-r450784d/bin:$PATH"
export LLVM_LDFLAGS="-fuse-ld=mold"
export LD="mold"
export LLVM=1
export ARCH=arm64
export PLATFORM_VERSION=13

export KERNEL_ROOT="$(pwd)"

BUILD_OPTIONS="
ARCH=arm64 \
LLVM=1 \
LD=mold \
LLVM_LDFLAGS=-fuse-ld=mold \
CROSS_COMPILE=$PARENT_DIR/clang-r450784d/bin/aarch64-linux-gnu- \
CC=$PARENT_DIR/clang-r450784d/bin/clang \
KCFLAGS=-w \
KBUILD_BUILD_USER=ken \
KBUILD_BUILD_HOST=pkenti
"

make ${BUILD_OPTIONS} -j$(nproc --all) exynos850-a13xx_defconfig
make ${BUILD_OPTIONS} -j$(nproc --all) Image || exit 1
