nix-config
===

## Requirements
- [Nix](https://nixos.org/download)

## Getting started
```
$ nix --extra-experimental-features "nix-command flakes" run nixpkgs#git -- clone https://github.com/onnga-wasabi/nix-config.git
$ cd nix-config
$ nix --extra-experimental-features "nix-command flakes" shell nixpkgs#go-task -c task apply
```
