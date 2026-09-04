{
  lib,
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
      adguardhome
      caddy
      glance
      homeassistant
      unbound
      unifi
      uptime-kuma
      vaultwarden

      caddyVhosts
      shareUser

      profileServer
      nfs
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      self.nixosModules."${hostname}Disko"
      inputs.nix-topology.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileServer
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    { pkgs, ... }:
    {
      topology.self = {
        name = "${hostname}";
        hardware.info = "Mini secondary network and essential server";
      };

      networking.hostName = "${hostname}";

      services = {
        openssh.enable = true;
        resolved.settings.Resolve = lib.mkForce {
          DNSStubListener = false;
        };
      };

      boot.kernelParams = [
        "i915.enable_rc6=1"
        "i915.enable_fbc=1"
      ];

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
      };

      hardware = {
        cpu.intel.updateMicrocode = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-vaapi-driver
            libvdpau-va-gl
            intel-media-driver
          ];
          enable32Bit = true;
        };
        enableAllFirmware = true;
      };
    };
}
