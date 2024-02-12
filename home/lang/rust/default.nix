{ pkgs
, lib
, ...
}:
let
  my-cargo-pkgs = {
    csvlens = (
      pkgs.rustPlatform.buildRustPackage rec {
        pname = "csvlens";
        version = "v0.6.0";

        src = pkgs.fetchFromGitHub {
          owner = "YS-L";
          repo = pname;
          rev = version;
          hash = "sha256-KileDwgVnrbJ6sCv6d4PjnyYqrEmZK6JESYa7+rBneo=";
        };

        cargoHash = "sha256-v3yXSnGoHn+7uZWOyqdvvRTtbg0N8six53J05YYbn4A=";

        meta = with lib; {
          description = "Command line csv viewer";
          homepage = "https://github.com/YS-L/csvlens";
          license = licenses.mit;
          maintainers = [ ];
        };
      }
    );
  };
in
{
  home.packages =
    with pkgs;
    with my-cargo-pkgs;
    [
      cargo
      rustfmt
      csvlens
    ];
}
