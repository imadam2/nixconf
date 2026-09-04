{ inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosModules."${hostname}Hardware" =
    {
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ];

      boot = {
        kernelModules = [ ];
        extraModulePackages = [ ];
        initrd = {
          kernelModules = [ ];
          availableKernelModules = [
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
        };
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

      sdImage.compressImage = false;

      hardware.enableRedistributableFirmware = true;
    };
}
