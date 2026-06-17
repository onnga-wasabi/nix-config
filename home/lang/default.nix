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
    gopls # LSP
    (lib.lowPrio gotools) # goimports（bundle が ruby の bundler と衝突するため優先度を下げる）
    gofumpt # formatter
    golangci-lint # linter
    delve # debugger
    gomodifytags
    impl

    # java
    gradle
    jdk17
    jdt-language-server # LSP (jdtls)

    # scala
    coursier
    sbt
    # ※ Scala は nvim-metals が coursier 経由で metals を管理するため LSP は別途不要

    # kotlin
    kotlin
    kotlin-language-server # LSP
    ktlint # formatter / linter

    # javascript / typescript
    deno
    nodejs_22
    yarn
    vtsls # LSP
    vscode-langservers-extracted # eslint / json / html / css LSP
    prettier # formatter

    # grpc
    grpcurl

    # shell
    shellcheck
    shfmt
    bash-language-server # LSP

    # ruby
    ruby
    ruby-lsp # LSP
  ];
}
