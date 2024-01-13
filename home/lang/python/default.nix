{ config
, pkgs
, lib
, ...
}:
let
  my-python-pkgs = ps:
    with ps; [
      (
        buildPythonPackage rec {
          pname = "deserialize";
          version = "1.8.3";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-0aozmQ4Eb5zL4rtNHSFjEynfObUkYlid1PgMDVmRkwY=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            # Specify dependencies
            pkgs.python3Packages.numpy
          ];
        }
      )
    ];
in
{
  home.packages = with pkgs; [
    poetry
    (python311.withPackages my-python-pkgs)
  ];
}
