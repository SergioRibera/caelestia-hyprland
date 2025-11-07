{ config, pkgs, ... }:
let
  inherit (config) shell user;
in
{
  imports = [
    ./shell
    ./tools/bat.nix
    ./tools/git.nix
  ];

  home-manager.users.${user.username} = (
    { ... }:
    {
      programs = {
        carapace = {
          enable = shell.name == "nushell";
          enableNushellIntegration = true;
        };
        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            wlrobs
            advanced-scene-switcher
            obs-backgroundremoval
            obs-advanced-masks
            distroav
          ];
        };
      };
    }
  );
}
