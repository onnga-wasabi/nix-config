{ config
, pkgs
, ...
}: {
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
    nodejs_21
    yarn

    # grpc
    protobuf_23
    grpcurl

    # lua
    lua
    stylua

    # python
    python311Full

    # rust
    cargo
    rustfmt

    shellcheck
    shfmt
  ];
}
