# Rust Compiler Builder

[![Rust](https://img.shields.io/badge/Rust-Dev-orange.svg)](https://github.com/rust-lang/rust)

Builds the *Rust* compiler and [Tier 3 targets](https://doc.rust-lang.org/nightly/rustc/platform-support.html) using *GitHub Actions*.

## Usage

```sh
▸▸▸ Download commands ◂◂◂
download:               Download Rust sources
▸▸▸ Configure commands ◂◂◂
configure:              Configure Rust & LLVM with optimizations
configure-dev:          Configure Rust without optimizations
configure-dev-llvm:     Configure Rust & LLVM without optimizations
▸▸▸ Target Info commands ◂◂◂
show-target-info:       Show target info
▸▸▸ Utility commands ◂◂◂
help:                   Show this help
clean:                  Remove generated artifacts
prune:                  Remove all downloaded artifacts
▸▸▸ Documentation commands ◂◂◂
doc-build:              Build the documentation site [env: DOC_DIR=]
doc-serve:              Serve the documentation site [env: DOC_PORT=]
doc-clean:              Remove generated artifacts [env: DOC_DIR=]
▸▸▸ Offline commands ◂◂◂
offline:                Download prebuilt Rust binaries and cache them for offline use
```

<!--

## Show target information

```sh
build/x86_64-apple-darwin/stage2/bin/rustc --print target-list
build/x86_64-apple-darwin/stage2/bin/rustc -Z unstable-options --target=arm64e-apple-darwin --print target-spec-json
build/x86_64-apple-darwin/stage2/bin/rustc -Z unstable-options --target=arm64e-apple-ios --print target-spec-json
```

## Use Rust toolchain

```
CUSTOM_TOOLCHAIN_NAME=rust-$(echo $(build/x86_64-apple-darwin/stage2/bin/rustc -V) | cut -d' ' -f2)
rustup toolchain link ${CUSTOM_TOOLCHAIN_NAME} build/x86_64-apple-darwin/stage2
rustup default ${CUSTOM_TOOLCHAIN_NAME}

rustup show
rustc -Vv
```

## Show information about a binary

```sh
objdump --macho --private-header [binary_file]
otool -h <binary_file>

od -t x1 -j [start_byte_offset] -N [number_of_bytes_to_read] -An [filename]

```

## [Verbose Linker](https://github.com/rust-lang/rust/issues/38206)

```
export RUSTFLAGS="-C link-arg=-Wl,--verbose"
export RUSTC_LOG=rustc_codegen_ssa::back::link=trace
```

-->
