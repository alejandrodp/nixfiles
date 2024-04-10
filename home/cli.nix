{ config, lib, pkgs, ... }:
with lib;
{
  programs = {
    ## talvez esto debería moverse a base
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      initExtra = import ./zshrc.nix pkgs;
    };
    git = {
      enable = true;
      userEmail = "alejandrodp@protonmail.com";
      userName = "Alejandro Diaz";
    };
  };

  home.packages = with pkgs;
    [
      calc
      file
      gcc
      htop
      killall
      man-pages
      man-pages-posix
      neovim
      rar
      tree
      units
      unzip
      usbutils
      zip
    ];
}
