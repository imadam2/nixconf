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

      hardware = {
        cpu.amd.updateMicrocode = true;
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            rocmPackages.clr.icd
            mesa-demos

            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
            gst_all_1.gst-vaapi

            ffmpeg-full
            libva
            libva-utils
            libva-vdpau-driver
            libvdpau-va-gl
          ];
          extraPackages32 = with pkgs.pkgsi686Linux; [
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
            libva
          ];
        };
      };
    };
}
