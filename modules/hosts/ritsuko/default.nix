{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.ritsuko = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      ritsukoConfiguration
      ritsukoHardware
      ritsukoDisko
      homeManager
      inputs.nix-topology.nixosModules.default
      inputs.sc0710.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
          obs
        ];
      }
    ];
  };

  flake.nixosModules.ritsukoConfiguration =
    { config, ... }:
    {
      topology.self = {
        name = "ritsuko";
        hardware.info = "Ryzen 2600 Capture PC";
      };

      networking.hostName = "ritsuko";

      powerManagement.cpuFreqGovernor = "performance";

      boot = {
        kernelParams = [
        ];
        extraModprobeConfig = "";
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      hardware = {
        sc0710.enable = true;
        cpu.amd.updateMicrocode = true;
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          open = true;
          modesetting.enable = true;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };
      };
    };
}
