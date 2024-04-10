{ config, lib, ... }:
with lib;
{
  options.local = with types; {
    platform = mkOption {
      type = str;
    };

    display = {
      "0" = mkOption {
        type = str;
      };

      "1" = mkOption {
        type = nullOr str;
      };

      autorandrProfile = mkOption {
        type = attrs;
      };

    };

    nixos = mkOption {
      type = bool;
    };
  };
}
