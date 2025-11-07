{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config) user;
  inherit (user) username;
in
{
  imports = [
    ./packages.nix
    ./programs.nix
  ];

  virtualisation =
    let
      hasNvidia = builtins.elem "nvidia" config.boot.initrd.kernelModules;
    in
    {
      docker = {
        enable = true;
        enableOnBoot = true;
        daemon.settings.features.cdi = hasNvidia;
      };
    };

  users = {
    defaultUserShell = pkgs."${config.shell.name}";
    mutableUsers = true;
    users."${username}" = {
      isNormalUser = user.isNormalUser;
      name = username;
      home = user.homepath;
      extraGroups = user.groups;
      initialPassword = "test";
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users."${username}" =
    { ... }:
    {
      programs.home-manager.enable = true;
      _module.args = { inherit inputs config; };

      home = {
        inherit username;
        homeDirectory = user.homepath;
        stateVersion = user.osVersion;
      };

      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
    };
}
