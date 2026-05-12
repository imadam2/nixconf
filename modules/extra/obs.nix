{ inputs, ... }:
{
  flake.homeModules.obs =
    { pkgs, ... }:
    {
      catppuccin.obs.enable = true;

      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      programs = {
        obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
          ];
        };
      };
    };
}
