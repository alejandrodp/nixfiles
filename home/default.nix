{ self, nixpkgs, unstable, hm-isolation, nixGL }:
{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    (hm-isolation.homeManagerModule)
    ./apps
    ./allowUnfreeWhitelist.nix
    ./gui
    ./isolation.nix
    ./options.nix
    ./cli.nix
    ./systemd
  ];

  nixpkgs.overlays = [ self.overlay nixGL.overlay ];

  home = {
    stateVersion = "23.11"; # No tocar esto
    username = "adp";
    homeDirectory = "/home/adp";
    sessionVariables = {
      "EDITOR" = "nano";
      "TERMINAL" = "xterm-256color";
    };
    keyboard = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  xdg.enable = true;

  nix.registry = {
    "system".to = {
      type = "path";
      path = "/home/adp/nix";
    };

    "nixpkgs".flake = nixpkgs;
    "unstable".flake = unstable;
  };

  programs.home-manager.enable = true;

  local = {
    apps.enable = mkDefault (!config.home.isolation.active);

    gui = {
      enable = mkDefault true;
      desktop = mkDefault (!config.home.isolation.active);
    };
  };
}

