{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (config) shell user;
  isNushell = shell.name == "nushell";
  nuPkg = (
    pkgs.nushell.overrideAttrs (prev: {
      doCheck = false;
    })
  );
in
{
  system.userActivationScripts.nushell.text =
    with pkgs.nushellPlugins;
    lib.optionalString isNushell ''
      ${nuPkg}/bin/nu -c "plugin add ${gstat}/bin/nu_plugin_gstat"
      ${nuPkg}/bin/nu -c "plugin use ${gstat}/bin/nu_plugin_gstat"
    '';

  home-manager.users."${user.username}" = {
    xdg = lib.mkIf (pkgs.stdenv.buildPlatform.isLinux) {
      configFile."nushell/prompt.nu" = lib.mkIf isNushell {
        source = ./prompt.nu;
      };
      configFile."nushell/ggit.nu" = lib.mkIf isNushell {
        source = ./ggit.nu;
      };
      configFile."nushell/carapace.nu" = lib.mkIf isNushell {
        source = ./carapace.nu;
      };
    };
    programs.nushell = {
      enable = isNushell;
      configFile.source = ./config.nu;
      envFile.source = ./env.nu;
      shellAliases = shell.aliases;
      package = nuPkg;
    };
  };
}
