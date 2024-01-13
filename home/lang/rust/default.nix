{ pkgs
, lib
, ...
}:
let
  my-cargo-pkgs = {
    csvlens = (
      pkgs.rustPlatform.buildRustPackage rec {
        pname = "csvlens";
        version = "v0.5.1";

        src = pkgs.fetchFromGitHub {
          owner = "YS-L";
          repo = pname;
          rev = version;
          hash = "sha256-9zIi49iXFOARSZsz0iqzC7NfoiBngfNt6A7vZuwxItI=";
        };

        cargoHash = "sha256-YR9/UZkSnzMrmihJcpVV5cbg/FAmfqypYhmn/vJ1z+s=";

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
