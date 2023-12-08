# Rust Compiler Builder

[![Rust](https://img.shields.io/badge/Rust-Dev-orange.svg)](https://github.com/rust-lang/rust)

Builds the *Rust* compiler and [Tier 3 targets](https://doc.rust-lang.org/nightly/rustc/platform-support.html) using *GitHub Actions*.

## Usage

```sh
$ make
help:                    Show this help
download:                Download Rust sources
download-offline:        Download prebuilt Rust binaries
configure:               Configure Rust
configure-offline:       Configure Rust and LLVM
```
