#!/bin/bash

DIR="$(readlink -f .)"
PARENT_DIR="$(readlink -f "${DIR}/..")"

export PATH="$PARENT_DIR/clang-r450784d/bin:$PATH"
export CC=clang
export LD=ld.lld
export LLVM=1
export LLVM_IAS=1
export ARCH=arm64

BUILD_OPTIONS="
ARCH=arm64 \
LLVM=1 \
LLVM_IAS=1 \
CC=clang \
LD=ld.lld \
KCFLAGS=-w \
KBUILD_BUILD_USER=ken \
KBUILD_BUILD_HOST=pkenti
"

make ${BUILD_OPTIONS} -j$(nproc --all) exynos850-a13xx_defconfig
make ${BUILD_OPTIONS} -j$(nproc --all) Image || exit 1
