{ inputs, ... }:
{
  flake.homeModules.media =
    { pkgs, ... }:
    {
      imports = [
        inputs.spicetify-nix.homeManagerModules.default
      ];

      programs.spicetify =
        let
          spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          enable = true;
          enabledExtensions = with spicePkgs.extensions; [
            adblock
            hidePodcasts
            shuffle
          ];
        };

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
