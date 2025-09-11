{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui.halloy;
in
{
  options.local.gui.halloy.enable = mkEnableOption "Halloy";
  config = mkIf cfg.enable {
    programs.halloy = {
      enable = true;
      settings = {
        "servers.liberachat" = {

          server = "soju.notmp.io";
          username = "alejandrosoju/irc.libera.chat";
          chathistory = true;
          port = 6697;
          nickname = "alejandro";
          password = "password";
          nick_password = "alejandrino";
          infinite_scroll = true;
          channels = [
            "#lobster"
          ];
        };
      };
    };
  };
}
