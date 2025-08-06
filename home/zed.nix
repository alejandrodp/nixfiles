{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.programs.zed;

  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.zed = {
    enable = mkEnableOption "Zed, a high-performance, multiplayer code editor";

    package = mkOption {
      type = types.package;
      default = pkgs.zed-editor;
      defaultText = literalExpression "pkgs.zed-editor";
      description = "The zed editor package to use.";
    };

    settings = mkOption {
      type = with types; nullOr jsonFormat.type;
      default = null;
      description = "Declarative configuration tree for zed.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = mkIf (cfg.settings != null) {
      "zed/zed.config".source = jsonFormat.generate "zed.config" cfg.settings;
    };
  };
}
