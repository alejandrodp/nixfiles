# Edet this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration-custom.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmp.useTmpfs = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "glados"; # Define your hostname. !!mover esto a platform
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Costa_Rica";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "es_CR.UTF-8";
  console = {
    font = "Lat2-Terminus16"; # TODO
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    libinput.enable = true;
    displayManager.startx.enable = true;
  };

  hardware.opengl.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];

  users = {
    users.adp = {
      isNormalUser = true;
      uid = 1000; # nunca cambiar mi ID de usuario
      group = "adp";
      shell = pkgs.zsh;
      extraGroups = [ "users" "wheel" "networkmanager" "dialout" "libvirtd" ];
      hashedPasswordFile = "/persistent/shadow-adp";
    };
    users.root.password = "";
    groups.adp.gid = 1000;
    mutableUsers = false;
  };

  nixpkgs.config.allowUnfree = true;

  programs.dconf.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware.opengl.driSupport32Bit = true;

  services.openssh.enable = true;

  services.earlyoom = {
    enable = true;
    enableNotifications = true;
  };

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
    files = [
      "/etc/machine-id"
    ];

    users.adp = {
      directories = [
        "steam"
      ];
    };
  };

  system.stateVersion = "23.11"; # No tocar esto

}
