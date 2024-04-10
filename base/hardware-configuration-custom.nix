{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    luks.devices."toplevel" = {
      device = "/dev/disk/by-uuid/5c4df472-3eaa-4a54-98ef-6124cb23afc8";
      preLVM = true;
    };
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';

  fileSystems = {
    "/" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" "ssd" ];
    };

    "/toplevel" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = [ "subvol=/" ];
    };
    
    "/boot" = {
      device = "/dev/disk/by-uuid/B77C-ACA2";
      fsType = "vfat";
      options = [ "umask=027" ];
    };

    "/persistent" = {
      device = "/dev/root_vg/root";
      neededForBoot = true;
      fsType = "btrfs";
      options = [ "subvol=persistent" ];
    };


    "/nix" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

    "/home" = {
      device = "/dev/root_vg/root";
      fsType = "btrfs";
      options = [ "subvol=home" ];
    };


  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
