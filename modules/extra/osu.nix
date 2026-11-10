{ ... }:
{
  flake.nixosModules.osu =
    { ... }:
    {
      hardware.opentabletdriver = {
        enable = true;
        daemon.enable = true;
      };
    };

  flake.homeModules.osu =
    { pkgs, ... }:
    {
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/x-osu-skin-archive" = "osu!.desktop";
          "application/x-osu-beatmap-archive" = "osu!.desktop";
        };
      };

      home.packages = with pkgs; [
        osu-lazer-bin
      ];
    };
}
