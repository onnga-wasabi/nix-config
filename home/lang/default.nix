{ config
, pkgs
, ...
}: {
  imports = [
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
    protobuf_23
    grpcurl

    # lua
    lua
    stylua

    # shell
    shellcheck
    shfmt
  ];
}
