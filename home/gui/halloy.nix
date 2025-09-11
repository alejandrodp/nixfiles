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
        "buffer.channel.topic" = {
          enabled = true;
        };
        "servers.liberachat" = {

          server = "soju.notmp.io";
          username = "fghjreiowghe/irc.libera.chat";
          chathistory = true;
          port = 6697;
          nickname = "alejandro";
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
