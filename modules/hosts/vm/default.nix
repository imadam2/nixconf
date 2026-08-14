{ self, inputs, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      base
      vmConfiguration
      vmHardware
      vmDisko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
        ];
      }
    ];
  };

  flake.nixosModules.vmConfiguration =
    { pkgs, lib, ... }:
    {
      networking.hostName = "vm";
      hardware.graphics.enable = true;
      services.qemuGuest.enable = true;
      services.openssh.enable = true;
      # Disable documentation — saves real disk space and a bit of build time
      documentation.enable = false;
      documentation.nixos.enable = false;
      documentation.man.enable = false;

      # Don't install extra firmware/kernel modules you don't need
      hardware.enableAllFirmware = false;
      hardware.enableRedistributableFirmware = lib.mkForce false;

      # Disable systemd services you don't need
      services.udisks2.enable = false;
      services.printing.enable = false;

      # No X11/Wayland if headless
      services.xserver.enable = false;

      boot = {
        loader = {
          systemd-boot.enable = false;
          efi.canTouchEfiVariables = false;
          grub = {
            enable = true;
            devices = [ "/dev/vda" ];
          };
        };
      };
    };
}
