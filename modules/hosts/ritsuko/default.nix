{
  self,
  inputs,
  ...
}:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      mangowm
      profileDesktop
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      homeManager
      inputs.nix-topology.nixosModules.default
      inputs.sc0710.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          mangowm
          discord
          obs
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    { config, lib, ... }:
    {
      topology.self = {
        name = "${hostname}";
        hardware.info = "Ryzen 2600 Capture PC";
      };

      networking.hostName = "${hostname}";

      powerManagement.cpuFreqGovernor = "performance";

      services.xserver.videoDrivers = [ "nvidia" ];

      services.hypridle.enable = lib.mkForce false;

      systemd = {
        targets = {
          sleep.enable = false;
          suspend.enable = false;
          hibernate.enable = false;
          hybrid-sleep.enable = false;
        };
      };

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 200;
      };

      hardware = {
        sc0710.enable = true;
        cpu.amd.updateMicrocode = true;
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        nvidia = {
          open = false;
          modesetting.enable = true;
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
        };
      };
    };
}
