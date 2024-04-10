{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.local.apps.terminal;
in
{
  options.local.apps.terminal.enable = mkEnableOption "Terminal emulator settings";
  config.programs = mkIf cfg.enable {
    kitty = {
      enable = true;
      extraConfig = import ./kitty.conf.nix;
    };

    tmux = {
      enable = false;
      aggressiveResize = true;
      clock24 = true;
      escapeTime = 10;
      terminal = "xterm-256color";
      keyMode = "emacs";

      extraConfig = ''
        set -g mouse on
        set -ga update-environment " LIFT_PID"
        set -g set-titles on
        set -g renumber-windows on
        set -sa terminal-overrides ',xterm-termite:RGB'
        set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,} %H:%M %d-%b-%y"
      '';
    };
  };
}
