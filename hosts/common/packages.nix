{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Utils
    fd
    bat
    eza
    curl
    wget
    jq
    ouch
    gitui
    ripgrep
    bottom
    fastfetch

    nix-output-monitor

    # ssl
    openssl

    # Rust
    rust-bin.stable.latest.default
  ];
}
