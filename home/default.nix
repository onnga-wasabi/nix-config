{ config, pkgs, ... }:

{
  imports = [
    ./base
    ./editor
    ./lang

    ./direnv.nix
  ];

  home.username = "wasabi";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true; # Let Home Manager install and manage itself.
}
