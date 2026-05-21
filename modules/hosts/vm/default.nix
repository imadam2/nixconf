{ self, inputs, ... }:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      audio
      base
      desktop
      git
      nfs
      services
      shell
      stylix
      vmConfiguration
      vmHardware
      vmDisko
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          browser
          packages
          desktop
          neovim
          noctalia
          shell
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
      boot.loader.systemd-boot.enable = false;
      boot.loader.efi.canTouchEfiVariables = false;
      boot.loader.grub = {
        enable = true;
        devices = "/dev/vda";
      };
    };
}
