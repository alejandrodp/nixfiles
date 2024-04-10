{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.local.gui.startx;
in
{
  options.local.gui.startx.enable = mkEnableOption "startx";
  config = mkIf cfg.enable {
    xsession.enable = true;

    home.file.".xinitrc".source =
      let
        content =
          if config.local.nixos then ''
            exec ~/.xsession
          '' else ''
            exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ~/.xsession
          '';
      in
      pkgs.writeShellScript "xinitrc" content;
  };
}
