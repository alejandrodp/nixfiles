{ pkgs, config, lib, ... }:
with lib;
{
  home.isolation = {
    enable = true;
    btrfsSupport = true;
    defaults = {
      static = true;
      bindHome = "home/";
      persist = {
        base = "shenvs";
        btrfs = true;
      };
    };

    modulesUnder = ./shenvs;
  };
}
