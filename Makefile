RUST_PREBUILT_VERSION ?= 2023-11-13
RUST_PREBUILT_COMPONENTS ?= rust-std rustc cargo rustfmt
RUST_PREBUILT_CHANNELS ?= beta nightly
RUST_PREBUILT_TARGET ?= x86_64-apple-darwin
RUST_PREBUILT_OUTPUT_DIR ?= rust/build/cache

RUST_GIT_URL ?= https://github.com/rust-lang/rust.git
RUST_TOOLS ?= cargo,clippy,rustdoc,rustfmt,rust-analyzer,analysis,src
RUST_TARGETS ?= aarch64-apple-ios,aarch64-apple-darwin
RUST_HOST ?= x86_64-apple-darwin
RUST_VERBOSE ?= 0
RUST_CHANNEL ?= dev
RUST_DESCRIPTION ?= ""
RUST_INSTALL_DIR ?= install
RUST_DIST_FORMATS ?= xz
RUST_USE_LLD ?= false

# NOTE: use Makefile.local for customization
-include Makefile.local

.PHONY: help
help:			## Show this help
	@fgrep -h "## " $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/## //'

## ▸▸▸ Download commands ◂◂◂

.PHONY: download
download:		## Download Rust sources
	git clone --recurse-submodules -j8 ${RUST_GIT_URL}

.PHONY: download-offline
download-offline: SHELL:=/bin/bash
download-offline:	## Download prebuilt Rust binaries
	mkdir -p ${RUST_PREBUILT_OUTPUT_DIR}/${RUST_PREBUILT_VERSION}
	@for RUST_CHANNEL in ${RUST_PREBUILT_CHANNELS}; do \
		for RUST_COMPONENT in ${RUST_PREBUILT_COMPONENTS}; do \
			RUST_FILENAME=${RUST_PREBUILT_VERSION}/$${RUST_COMPONENT}-$${RUST_CHANNEL}-${RUST_PREBUILT_TARGET}.tar.xz ; \
			curl --fail https://static.rust-lang.org/dist/$${RUST_FILENAME} --output ${RUST_PREBUILT_OUTPUT_DIR}/$${RUST_FILENAME} ; \
		done; \
	done;

###
# Configure: https://github.com/rust-lang/rust/blob/master/src/bootstrap/configure.py
###

## ▸▸▸ Configure commands ◂◂◂

.PHONY: configure
configure:		## Configure Rust
	cd rust && ./configure \
		--enable-option-checking \
		--enable-verbose-tests \
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
		--set rust.use-lld=${RUST_USE_LLD} \
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
