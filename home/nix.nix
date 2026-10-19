{ pkgs, ... }: {
  # nix-darwin 側は nix.enable = false で /etc/nix/nix.conf を書かないので、
  # ユーザー設定（~/.config/nix/nix.conf）として渡す。
  # nix.package は設定の検証に使われるだけで、nix 本体は入れ替わらない。
  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
}
