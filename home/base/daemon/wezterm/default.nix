{ pkgs
, ...
}:
let

  inherit (pkgs) system;
  customPkgs = {
    wezterm =
      let
        pkgs = import
          (builtins.fetchTarball {
            url = "https://github.com/NixOS/nixpkgs/archive/c3392ad349a5227f4a3464dce87bcc5046692fce.tar.gz";
            sha256 = "1klhr7mrfhrzcqfzngk268jspikbivkxg96x2wncjv1ik3zb8i75";
          })
          {
            inherit system;
          };
      in
      pkgs.wezterm;
  };
in
{
  home.packages = [
    customPkgs.wezterm
  ];
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
}
