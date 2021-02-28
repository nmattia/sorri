# SORRI

Just Add Water direnv support for the nix-shell.

* [Install](#install)
* [How It Works](#how-it-works)

## Install

Add `sorri` to your project:

```
$ curl https://raw.githubusercontent.com/nmattia/sorri/master/sorri --create-dirs --output nix/sorri
```

Update your `.envrc` to use `sorri`:

```
$ echo ". nix/sorri $(basename $PWD)" > .envrc
```

You're all set!

### The sorri helper

The `sorri` helper bootstraps projects for you. Install it with:

```
nix-env -if https://github.com/nmattia/sorri/tarball/master
```

... and from then on use:

```
$ sorri init
```

inside your project.

## How It Works

This is a simple, lightweight implementation of Tweag's
[lorri](https://github.com/target/lorri)

sorri reuses lorri's tricks for figuring out the files to track for changes,
but uses direnv's own mechanism for actually tracking those files.
sorri uses a local cache at '~/.cache/sorri/<project>/v<sorri version>/'.
Each entry is a directory containing two files:

```
  ~/.cache/sorri/niv/v1/
  └── 0716a121e4f986f9f8cf11f7c579d332
      ├── link -> /nix/store/jfzkisfgmv3qgpzz3i8nai12y1cry77v-nix-shell
      └── manifest
```

`link` is the result of a previous evaluation. `manifest` is used to find
that result of a previous evaluation. The directory name
(0716a121e4f986f9f8cf11f7c579d332 above) is the hash of the `manifest`.

`link` is a symlink to a shell script that sets a shell's variables.

```
  cat ~/.cache/sorri/niv/v1/0716a121e4f986f9f8cf11f7c579d332/link
  declare -x AR_x86_64_apple_darwin="/nix/store/amsm28x2hnsgp8c0nm4glkjc2gw2l9kw-cctools-binutils-darwin-927.0.2/bin/ar"
  declare -x BZ2_LIB_DIR="/nix/store/7yikqcm4v4b57xv3cqknhdnf0p1aakxp-bzip2-1.0.6.0.1/lib"
  declare -x BZ2_STATIC="1"
  declare -x CARGO_BUILD_TARGET="x86_64-apple-darwin"
  declare -x CARGO_TARGET_WASM32_UNKNOWN_UNKNOWN_LINKER="/nix/store/swiic36rl7njy6bfll5z0afl42c9q4s5-lld-9.0.1/bin/lld"
```

`manifest` is a list of files used for an evaluation alongside their checksums:

```
  $ cat ~/.cache/sorri/niv/v1/0716a121e4f986f9f8cf11f7c579d332/manifest
  /Users/nicolas/niv/shell.nix:029451f2a9bee59f4ce002bdbdf20554
  /Users/nicolas/niv/nix/default.nix:7ff8c9138044fc7e31f1d4ed2bf1c0ba
  /Users/nicolas/niv/nix/overlays/buf/default.nix:c4a24e0bba0178b73f0211d0f26147e6
  ...
```

sorri first checks the existing cache entries (sorri/niv/v1/0716...,
etc); if it finds a cache entry with a manifest where all the _manifest_
entries (nix/default.nix:7ff...) match local files, the link is loaded; if no
manifest matches, a new entry is created and loaded.
