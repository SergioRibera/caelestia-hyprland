{ pkgs, ... }:
{
  boot = {
    consoleLogLevel = 0;
    tmp.cleanOnBoot = true;
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=auto"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];

    initrd = {
      verbose = false;
      supportedFilesystems = [ "ntfs" ];
    };

    loader = {
      timeout = pkgs.lib.mkDefault 3;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };

    plymouth = {
      enable = true;
      theme = "mac-style";
      themePackages = [ pkgs.mac-style-plymouth ];
    };
  };
}
