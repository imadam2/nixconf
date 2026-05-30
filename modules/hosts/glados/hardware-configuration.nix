{
  flake.nixosModules.gladosHardware =
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
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "uas"
            "sd_mod"
          ];
        };
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
