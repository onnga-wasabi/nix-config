{ configlangde
, pkgs
, ...
}: {
  imports = [
    ./lua
    ./python
    ./rust
  ];
  home.packages = with pkgs; [
    # golang
    go
    richgo

    # java
    gradle
    jdk17

    # scala
    coursier
    sbt

    # kotlin
    kotlin

    # javascript
    deno
    nodejs_22
    yarn

    # grpc
    grpcurl

    # shell
    shellcheck
    shfmt

    ruby
  ];
}
