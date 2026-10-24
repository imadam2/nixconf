{ lib, inputs, ... }:
{
  flake.homeModules.media =
    { pkgs, ... }:
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.default
      ];

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "audio/flac" = [ "mpv.desktop" ];
          "audio/mpeg" = [ "mpv.desktop" ];
          "audio/ogg" = [ "mpv.desktop" ];
          "video/avi" = [ "mpv.desktop" ];
          "video/mkv" = [ "mpv.desktop" ];
          "video/mp4" = [ "mpv.desktop" ];
          "video/webm" = [ "mpv.desktop" ];
          "video/x-matroska" = [ "mpv.desktop" ];
          "video/x-mkv" = [ "mpv.desktop" ];
        };
      };

      programs.spicetify =
        let
          spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;
          enabledExtensions = with spicePkgs.extensions; [
            adblock
            hidePodcasts
            keyboardShortcut
            shuffle
          ];
          theme = lib.mkForce spicePkgs.themes.text;
          colorScheme = lib.mkForce "CatppuccinMocha";
        };

      home.packages = with pkgs; [
        ffmpeg
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
