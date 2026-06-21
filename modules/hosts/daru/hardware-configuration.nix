{
  flake.nixosModules.daruHardware =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        initrd = {
          kernelModules = [ ];
          availableKernelModules = [
            "ata_generic"
            "ehci_pci"
            "ahci"
            "isci"
            "xhci_pci"
            "firewire_ohci"
            "usb_storage"
            "usbhid"
            "sd_mod"
            "sr_mod"
          ];
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-uuid/261b7b72-5359-4405-ac9b-5821722e7ebe";
          fsType = "btrfs";
          options = [ "subvol=@" ];
        };

        "/nix" = {
          device = "/dev/disk/by-uuid/261b7b72-5359-4405-ac9b-5821722e7ebe";
          fsType = "btrfs";
          options = [ "subvol=@nix" ];
        };

        "/.snapshots" = {
          device = "/dev/disk/by-uuid/261b7b72-5359-4405-ac9b-5821722e7ebe";
          fsType = "btrfs";
          options = [ "subvol=@.snapshots" ];
        };

        "/home" = {
          device = "/dev/disk/by-uuid/261b7b72-5359-4405-ac9b-5821722e7ebe";
          fsType = "btrfs";
          options = [ "subvol=@home" ];
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/5EE9-01AF";
          fsType = "vfat";
          options = [
            "fmask=0177"
            "dmask=0077"
          ];
        };
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
