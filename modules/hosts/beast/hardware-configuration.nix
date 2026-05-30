{
  flake.nixosModules.beastHardware =
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

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
