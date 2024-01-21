{ pkgs ? import <nixpkgs> { } }:
let
  # https://lazamar.co.uk/nix-versions/?package=terraform&version=0.13.7&fullName=terraform-0.13.7&keyName=terraform_0_13&revision=f597e7e9fcf37d8ed14a12835ede0a7d362314bd&channel=nixpkgs-unstable#instructions
  fetchPkg = import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/f597e7e9fcf37d8ed14a12835ede0a7d362314bd.tar.gz";
    })
    { };
  terrafrom_0_13 = fetchPkg.terraform_0_13;
in
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs =
    with pkgs.buildPackages; [
      ruby_3_2
    ];
  buildInputs = [
    terrafrom_0_13
  ];
}
