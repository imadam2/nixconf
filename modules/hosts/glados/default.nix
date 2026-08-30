{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.glados = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      flaresolverr
      immich
      jellyfin
      prowlarr
      qbittorrent
      radarr
      seerr
      share
      slskd
      sonarr
      syncthing

      gladosDrives
      shareUser

      profileServer
      gladosConfiguration
      gladosHardware
      gladosDisko
      inputs.nix-topology.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileServer
        ];
      }
    ];
  };

  flake.nixosModules.gladosConfiguration =
    { pkgs, ... }:
    {
      topology.self = {
        name = "Glados";
        hardware.info = "2U Main media and storage server";
      };

      networking = {
        hostName = "glados";
        firewall = {
          allowedTCPPorts = [
            27973
          ];
          allowedUDPPorts = [
            27973
          ];
        };
      };

      systemd.services.agent = {
        description = "Glance Agent";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "/home/ye/agent";
          Restart = "on-failure";
          User = "ye"; # run as your user, not root
        };
      };

      environment.systemPackages = with pkgs; [
        hddtemp
        hdparm
        intel-gpu-tools
        powertop
        smartmontools
      ];

      services = {
        openssh.enable = true;
      };

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 200;
      };

      #boot.kernelParams = [
      #  "i915.enable_guc=2"
      #];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "schedutil";
      };

      hardware.enableRedistributableFirmware = true;

      hardware = {
        cpu.intel.updateMicrocode = true;
        enableAllFirmware = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver
            vpl-gpu-rt
            intel-compute-runtime
          ];
          enable32Bit = true;
        };
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    };
}
