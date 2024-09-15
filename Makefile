RUST_GIT_URL ?= https://github.com/rust-lang/rust.git
RUST_TOOLS ?= cargo,clippy,rustdoc,rustfmt,rust-analyzer,analysis,src
RUST_TARGETS ?= aarch64-apple-darwin,aarch64-apple-ios,arm64e-apple-darwin,arm64e-apple-ios
RUST_HOST ?= x86_64-apple-darwin
RUST_VERBOSE ?= 0
RUST_CHANNEL ?= dev
RUST_DESCRIPTION ?= ""
RUST_INSTALL_DIR ?= install
RUST_DIST_FORMATS ?= xz
RUST_USE_LLD ?= false

.PHONY: help
help:			## Show this help
	@fgrep -h "## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/## //'

# Note: use Makefile.local for customization
-include misc/make/offline.Makefile
-include Makefile.local

## ▸▸▸ Download commands ◂◂◂

.PHONY: download
download:		## Download Rust sources
	git clone --recurse-submodules -j8 ${RUST_GIT_URL}

###
# Configure: https://github.com/rust-lang/rust/blob/master/src/bootstrap/configure.py
###

## ▸▸▸ Configure commands ◂◂◂

.PHONY: configure
configure:		## Configure Rust
	cd rust && ./configure \
		--enable-option-checking \
		--enable-verbose-tests \
		--codegen-backends=llvm \
		--enable-codegen-tests \
		--enable-dist-src \
		--tools=${RUST_TOOLS} \
		--target=${RUST_TARGETS} \
		--set llvm.download-ci-llvm=true \
		--set build.verbose=${RUST_VERBOSE} \
		--set rust.channel=${RUST_CHANNEL} \
		--set rust.description=${RUST_DESCRIPTION} \
		--set rust.use-lld=${RUST_USE_LLD} \
		--dist-compression-formats=${RUST_DIST_FORMATS} \
		--prefix=${RUST_INSTALL_DIR}

.PHONY: configure-with-llvm
configure-with-llvm:	## Configure Rust and LLVM
	cd rust && ./configure \
		--enable-option-checking \
		--enable-sccache \
		--enable-ninja \
		--enable-verbose-tests \
		--enable-codegen-tests \
		--enable-dist-src \
		--enable-full-tools \
		--tools=${RUST_TOOLS} \
		--target=${RUST_TARGETS} \
		--set llvm.download-ci-llvm=false \
		--set llvm.targets="AArch64;X86" \
		--set llvm.experimental-targets="" \
		--set llvm.tests=true \
		--set build.verbose=${RUST_VERBOSE} \
		--set rust.channel=${RUST_CHANNEL} \
		--set rust.description=${RUST_DESCRIPTION} \
		--set rust.omit-git-hash=true \
		--dist-compression-formats=${RUST_DIST_FORMATS} \
		--prefix=${RUST_INSTALL_DIR}

## ▸▸▸ Target Info commands ◂◂◂

.PHONY: show-target-info
show-target-info: SHELL:=/bin/bash
show-target-info:	## Show target info
	@for RUST_TARGET in $(shell echo ${RUST_TARGETS} | tr "," " "); do \
		rust/build/${RUST_HOST}/stage2/bin/rustc -Z unstable-options --target=$${RUST_TARGET} --print target-spec-json | tee $${RUST_TARGET}-spec.json ; \
	done;
