{ config, pkgs, ... }:
{
  imports = [
    # ./hardware-configuration.nix
  ];

  # Prioritize performance over efficiency
  powerManagement.cpuFreqGovernor = "performance";

  bluetooth = false;

  terminal = {
    name = "alacritty";
    command = [
      "alacritty"
      "-e"
    ];
  };
  shell = {
    name = "nushell";
    command = [ "nu" ];
    privSession = [
      "nu"
      "--no-history"
    ];
  };

  user = {
    isNormalUser = true;
    browser = "firefox";
    groups = [
      "wheel"
      "video"
      "audio"
      "docker"
      "networkmanager"
      "input"
      "dialout"
    ];
  };

  services.displayManager.gdm.wayland = true;

  wm.screens =
    let
      height = 1080;
    in
    [
      {
        name = "DP-4";
        rotation = "right";
      }
      {
        name = "DP-3";
        position.x = height;
      }
      {
        name = "DP-5";
        position = {
          x = height;
          y = height;
        };
      }
      {
        name = "HDMI-A-2";
        position.x = 3000;
        rotation = "right";
      }
    ];
}
