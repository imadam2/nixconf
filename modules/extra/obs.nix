{ ... }:
{
  flake.nixosModules.obs =
    { ... }:
    {
      programs.obs-studio.enableVirtualCamera = true;
    };
  flake.homeModules.obs =
    { pkgs, ... }:
    {
      programs = {
        obs-studio = {
          enable = true;
          package = (pkgs.obs-studio.override { cudaSupport = true; });
          plugins = with pkgs.obs-studio-plugins; [
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
          ];
        };
      };
    };
}
