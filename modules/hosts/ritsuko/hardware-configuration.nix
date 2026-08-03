{
  flake.nixosModules.ritsukoHardware =
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
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
        initrd = {
          kernelModules = [ ];
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usb_storage"
            "usbhid"
            "sd_mod"
          ];
        };
      };

      fileSystems = {
        "/" = {
          device = "/dev/nvme0n1p5";
          fsType = "btrfs";
          options = [
            "subvol=@"
            "compress=zstd:2"
          ];
        };

        "/nix" = {
          device = "/dev/nvme0n1p5";
          fsType = "btrfs";
          options = [
            "subvol=@nix"
            "compress=zstd:2"
          ];
        };

        "/.snapshots" = {
          device = "/dev/nvme0n1p5";
          fsType = "btrfs";
          options = [
            "subvol=@.snapshots"
            "compress=zstd:2"
          ];
        };

        "/home" = {
          device = "/dev/nvme0n1p5";
          fsType = "btrfs";
          options = [
            "subvol=@home"
            "compress=zstd:2"
          ];
        };

        "/boot" = {
          device = "/dev/nvme0n1p1";
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
