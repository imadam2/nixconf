{ self, inputs, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      jellyfin
      profileServer
      vmConfiguration
      vmHardware
      vmDisko
      homeManager
      inputs.disko.nixosModules.disko
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileServer
        ];
      }
    ];
  };

  flake.nixosModules.vmConfiguration =
    { ... }:
    {
      networking.hostName = "vm";

      hardware.graphics.enable = true;
      services.qemuGuest.enable = true;
      services.openssh.enable = true;

      virtualisation.vmVariant = {
        virtualisation = {
          memorySize = 4096;
          cores = 4;
        };
      };

      users = {
        groups.vm = { };
        users = {
          vm = {
            isNormalUser = true;
            initialPassword = "test";
            group = "vm";
          };
        };
      };

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
