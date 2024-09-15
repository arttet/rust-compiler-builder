RUST_PREBUILT_VERSION ?= $(shell curl --silent https://static.rust-lang.org/dist/channel-rust-beta.toml | grep '^date = "' | sed 's/date = "\(.*\)"/\1/')
RUST_PREBUILT_COMPONENTS ?= rust-std rustc cargo rustfmt
RUST_PREBUILT_CHANNELS ?= beta nightly
RUST_PREBUILT_TARGET ?= x86_64-apple-darwin
RUST_PREBUILT_OUTPUT_DIR ?= rust/build/cache

## ▸▸▸ Offline commands ◂◂◂

.PHONY: offline
offline: SHELL:=/bin/bash
offline:		## Download prebuilt Rust binaries and cache them for offline use
	mkdir -p ${RUST_PREBUILT_OUTPUT_DIR}/${RUST_PREBUILT_VERSION}
	@for RUST_CHANNEL in ${RUST_PREBUILT_CHANNELS}; do \
		for RUST_COMPONENT in ${RUST_PREBUILT_COMPONENTS}; do \
			RUST_FILENAME=${RUST_PREBUILT_VERSION}/$${RUST_COMPONENT}-$${RUST_CHANNEL}-${RUST_PREBUILT_TARGET}.tar.xz ; \
			INFO="\nFile Name: $${RUST_FILENAME}\nSize: %{size_download} bytes\nSpeed: %{speed_download} bytes/sec\nTime: %{time_total} seconds\n\n" ; \
			URL=https://static.rust-lang.org/dist/$${RUST_FILENAME} ; \
			OUTPUT=${RUST_PREBUILT_OUTPUT_DIR}/$${RUST_FILENAME} ; \
			curl --fail --progress-bar --write-out "$${INFO}" $${URL} --output $${OUTPUT} ; \
		done; \
	done;
