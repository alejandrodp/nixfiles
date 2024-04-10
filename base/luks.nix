{ lib, config, pkgs, ... }:
with lib; let
  cfg = config.local;
in
{
  options.local = with lib.types; {
    loader = mkOption {
      type = enum [ "grub" "systemd-boot" ];
    };

    cpuVendor = mkOption {
      type = enum [ "amd" "intel" ];
    };

    canTouchEfiVariables = mkOption {
      type = bool;
    };

    videoDrivers = mkOption {
      type = listOf str;
    };

    initrdModules = mkOption {
      type = listOf str;
    };
  };

  config = {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;

      loader = (if cfg.loader == "grub" then {
        grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
        };
      } else {
        systemd-boot.enable = true;
      }) // {
        efi = {
          inherit (cfg) canTouchEfiVariables;
        };
      };

      initrd =
        let
          crypt = cfg.crypt.toplevel;
          headerPathEscaped = escapeShellArg "/initrd-boot/${crypt.headerFromBoot}";
        in
        {
          availableKernelModules = cfg.initrdModules;
          supportedFilesystems = [ "vfat" ];

          preDeviceCommands = optionalString (crypt != null) ''
            mkdir -p `dirname ${headerPathEscaped}`
            touch ${headerPathEscaped}
          '';

          preLVMCommands = optionalString cfg.portable ''
            sleep 2 #TODO
          '';

          postMountCommands =
            let
              fromRoot = path: escapeShellArg "/mnt-root/${path}";
              auxOpen = aux: ''
                cryptsetup -v open \
                  --header ${fromRoot aux.header} \
                  --key-file ${fromRoot aux.keyfile} \
                  ${aux.device} ${aux.target}
              '';
            in
            concatStringsSep "\n" (map auxOpen cfg.crypt.aux);

          luks.devices = mkIf (crypt != null) {
            "${crypt.target}" = {
              inherit (crypt) device;
              header = "/initrd-boot/${crypt.headerFromBoot}";
              preLVM = false;

              preOpenCommands = ''
                mount -o ro -t vfat ${escapeShellArg cfg.fs.boot.device} /initrd-boot
              '';

              postOpenCommands = ''
                umount /initrd-boot
              '';
            };
          };
        };
    };

    hardware.cpu =
      let
        ucode.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      in
      {
        amd = mkIf (cfg.cpuVendor == "amd") ucode;
        intel = mkIf (cfg.cpuVendor == "intel") ucode;
      };
  };
}
