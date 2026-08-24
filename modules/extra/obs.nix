{ ... }:
{
  flake.homeModules.obs =
    { pkgs, ... }:
    {

      networking.firewall = {
        allowedUDPPorts = [
          5353
          5960
          5961
          5962
          5963
          6960
          6961
          6962
          6963
          7960
          7961
          7962
          7963
        ];
        allowedTCPPorts = [
          5959
          5960
          6960
          6961
          6962
          6963
          7960
          7961
          7962
          7963
        ];
      };
      programs = {
        obs-studio = {
          enable = true;
          package = (pkgs.obs-studio.override { cudaSupport = true; });
          plugins = with pkgs.obs-studio-plugins; [
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
            distroav
          ];
        };
      };
    };
}
