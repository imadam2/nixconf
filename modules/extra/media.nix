{ inputs, ... }:
{
  flake.homeModules.media =
    { pkgs, ... }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
      ];

      catppuccin.mpv.enable = true;

      home.packages = with pkgs; [
        ffmpeg
        imv
        jellyfin-media-player
        jellyfin-tui
      ];

      programs = {
        mpv.enable = true;
        yt-dlp.enable = true;
        zathura.enable = true;
      };
    };
}
