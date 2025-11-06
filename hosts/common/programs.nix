{ ... }:
{
  programs = {
    dconf.enable = true;
    nh = {
      enable = true;
      flake = "/etc/nixos";
    };
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      loadInNixShell = true;
    };
    ssh = {
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
  };
}
