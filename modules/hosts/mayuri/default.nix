{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.mayuri = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      gaming
      virtualization
      mayuriConfiguration
      mayuriHardware
      mayuriDisko
      homeManager
      inputs.nix-topology.nixosModules.default
      {
        home-manager.users.ye.imports = with self.homeModules; [
          discord
          profileDesktop
          gaming
          obs
        ];
      }
    ];
  };

  flake.nixosModules.mayuriConfiguration =
    { pkgs, ... }:
    {
      topology.self = {
        name = "mayuri";
        hardware.info = "Main Ryzen 5800x Desktop";
      };

      networking.hostName = "mayuri";

      powerManagement.cpuFreqGovernor = "performance";

      boot = {
        binfmt.emulatedSystems = [ "aarch64-linux" ];
        kernelParams = [
          "amd_iommu=on"
          "iommu=pt"
          "pcie_aspm=off"
          "mitigations=off"
          "amd_pstate=active"
        ];
        extraModprobeConfig = ''
          options amdgpu ppfeaturemask=0xffffffff
          options amdgpu overdrive=1
        '';
      };

      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
        motherboard = "amd";
        server.port = 6742;
      };

      systemd.user.services.openrgb-blue-profile = {
        description = "Apply Blue OpenRGB Direct Mode to Motherboard Devices";
        wantedBy = [ "mango-session.target" ];
        after = [ "mango-session.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.openrgb}/bin/openrgb --device \"ASUS ROG STRIX B450-F GAMING II\" --mode Direct --color 1D79D0 --device \"ASUS ROG STRIX B450-F GAMING II Addressable\" --mode Direct --color 1D79D0";
        };
      };

      hardware = {
        cpu.amd.updateMicrocode = true;
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            mesa-demos

            ffmpeg-full
            libva
            libva-utils
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            libva
          ];
        };
      };
    };
}
