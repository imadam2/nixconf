{
  flake.nixosModules.vmHardware =
    { lib, ... }:
    {
      boot = {
        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
        initrd = {
          kernelModules = [ ];
          availableKernelModules = [
            "ahci"
            "xhci_pci"
            "virtio_pci"
            "sr_mod"
            "virtio_blk"
          ];
        };
      };

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
