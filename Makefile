.DEFAULT_GOAL := help

################################################################################

RUST_GIT_URL ?= https://github.com/rust-lang/rust.git
RUST_HOST ?= x86_64-apple-darwin
RUST_TARGETS ?= arm64e-apple-darwin
RUST_TOOLS ?= cargo,clippy,rustdoc,rustfmt,rust-analyzer,analysis,src
RUST_CHANNEL ?= dev
RUST_CODEGEN_BACKENDS ?= llvm
RUST_USE_LLD ?= false
RUST_VERBOSE ?= 0
RUST_DESCRIPTION ?= ""
RUST_INSTALL_DIR ?= install
RUST_DIST_FORMATS ?= xz
RUST_CONFIGURE_ARGS ?=

# Note: use Makefile.local for customization
-include misc/make/utility.Makefile
-include misc/make/doc.Makefile
-include misc/make/offline.Makefile
-include Makefile.local

## ▸▸▸ Download commands ◂◂◂

.PHONY: download
download:		## Download Rust sources
	git clone --recurse-submodules -j$(shell nproc) ${RUST_GIT_URL}

###
# Configure: https://github.com/rust-lang/rust/blob/master/src/bootstrap/configure.py
###

## ▸▸▸ Configure commands ◂◂◂

.PHONY: configure
configure:		## Configure Rust & LLVM with optimizations
	cd rust && ./configure \
		--enable-option-checking \
		--enable-verbose-configure \
		--enable-sccache \
		--enable-ninja \
		--enable-verbose-tests \
		--enable-codegen-tests \
		--enable-dist-src \
		--enable-optimize-llvm \
		--enable-full-tools \
		--enable-sanitizers \
		--enable-profiler \
		--host=${RUST_HOST} \
		--target=${RUST_TARGETS} \
		--set llvm.download-ci-llvm=false \
		--set llvm.targets="AArch64;X86" \
		--set llvm.experimental-targets="" \
		--set llvm.static-libstdcpp \
		--set llvm.tests=true \
		--set build.verbose=${RUST_VERBOSE} \
		--set rust.channel=${RUST_CHANNEL} \
		--set rust.jemalloc \
		--set rust.lto=thin \
		--set rust.codegen-units=1 \
		--set rust.codegen-backends=${RUST_CODEGEN_BACKENDS} \
		--set rust.use-lld=${RUST_USE_LLD} \
		--set rust.omit-git-hash=true \
		--dist-compression-formats=${RUST_DIST_FORMATS} \
		--prefix=${RUST_INSTALL_DIR} \
		${RUST_CONFIGURE_ARGS}

.PHONY: configure-dev
configure-dev:		## Configure Rust without optimizations
	cd rust && ./configure \
		--enable-option-checking \
		--enable-verbose-configure \
		--enable-verbose-tests \
		--enable-codegen-tests \
		--host=${RUST_HOST} \
		--target=${RUST_TARGETS} \
		--tools=${RUST_TOOLS} \
		--set llvm.download-ci-llvm=true \
		--set build.verbose=${RUST_VERBOSE} \
		--set rust.channel=${RUST_CHANNEL} \
		--set rust.description=${RUST_DESCRIPTION} \
		--set rust.use-lld=${RUST_USE_LLD} \
		--dist-compression-formats=${RUST_DIST_FORMATS} \
		--prefix=${RUST_INSTALL_DIR} \
		${RUST_CONFIGURE_ARGS}

.PHONY: configure-dev-llvm
configure-dev-llvm:	## Configure Rust & LLVM without optimizations
	cd rust && ./configure \
		--enable-option-checking \
		--enable-verbose-configure \
		--enable-verbose-tests \
		--enable-codegen-tests \
		--enable-sccache \
		--enable-ninja \
		--host=${RUST_HOST} \
		--target=${RUST_TARGETS} \
		--tools=${RUST_TOOLS} \
		--enable-debug-assertions \
		--enable-overflow-checks \
		--enable-llvm-assertions \
		--codegen-backends=${RUST_CODEGEN_BACKENDS} \
		--set llvm.download-ci-llvm=false \
		--set llvm.targets="AArch64;X86" \
		--set llvm.experimental-targets="" \
		--set llvm.static-libstdcpp \
		--set llvm.tests=true \
		--set build.verbose=${RUST_VERBOSE} \
		--set rust.channel=${RUST_CHANNEL} \
		--set rust.verify-llvm-ir \
		--set rust.use-lld=${RUST_USE_LLD} \
		--set rust.codegen-backends=${RUST_CODEGEN_BACKENDS} \
		--set rust.omit-git-hash=true \
		--dist-compression-formats=${RUST_DIST_FORMATS} \
		--prefix=${RUST_INSTALL_DIR} \
		${RUST_CONFIGURE_ARGS}

## ▸▸▸ Target Info commands ◂◂◂

.PHONY: show-target-info
show-target-info: SHELL:=/bin/bash
show-target-info:	## Show target info
	@for RUST_TARGET in $(shell echo ${RUST_TARGETS} | tr "," " "); do \
		rust/build/${RUST_HOST}/stage2/bin/rustc -Z unstable-options --target=$${RUST_TARGET} --print target-spec-json | tee $${RUST_TARGET}-spec.json ; \
	done;
