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
    ripgrep
    bottom

    nix-output-monitor

    # ssl
    openssl

    # Rust
    rust-bin.stable.latest.default
  ];
}
