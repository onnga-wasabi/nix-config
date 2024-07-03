{ lib
, pkgs
, ...
}:
let
  # This cannot be built from source since Hammerspoon requires entitlements to work,
  # and codesigning entitlements is unfortunately incompatible with immutability.
  hommerspoon = pkgs.stdenvNoCC.mkDerivation
    (self: {
      pname = "hammerspoon";
      version = "0.9.100";

      # We don't use fetchzip because that seems to unpack the .app as well.
      src = pkgs.fetchurl {
        name = "${self.pname}-${self.version}-source.zip";
        url = "https://github.com/Hammerspoon/hammerspoon/releases/download/${self.version}/Hammerspoon-${self.version}.zip";
        sha256 = "sha256-bc/IB8fOxpLK87GMNsweo69rn0Jpm03yd3NECOTgc5k=";
      };

      nativeBuildInputs = [
        # Adds unpack hook.
        pkgs.unzip
      ];

      installPhase = ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -r ../Hammerspoon.app $out/Applications/
        runHook postInstall
      '';

      meta = {
        homepage = "https://www.hammerspoon.org";
        description = "Staggeringly powerful macOS desktop automation with Lua";
        license = lib.licenses.mit;
        platforms = [ "x86_64-darwin" "aarch64-darwin" ];
      };
    });
in
{
  home.packages = [
    hommerspoon
  ];

  # you need run at once
  # defaults write org.hammerspoon.Hammerspoon MJConfigFile "$XDG_CONFIG_HOME/hammerspoon/init.lua"
  xdg.configFile."hammerspoon/init.lua" = {
    source = ./init.lua;
  };

  xdg.configFile."kitty/kitty.conf" = {
    source = ./kitty.conf;
  };
}
