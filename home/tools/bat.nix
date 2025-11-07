{ config, ... }:
{

  home-manager.users.${config.user.username}.programs.bat = {
    enable = true;
    config = {
      map-syntax = [
        "*.jenkinsfile:Groovy"
        "*.props:Java Properties"
      ];
      pager = "less -FR";
      style = "header-filename,header-filesize,rule,numbers,snip,changes,header";
    };
  };
}
