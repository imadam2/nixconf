{ ... }:
{
  flake.homeModules.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        _86Box-with-roms
        ddcutil
        evtest
        grim
        orca-slicer
        pavucontrol
        qbittorrent
        satty
        signal-desktop
        slurp
        thunar
        wl-clipboard
      ];
    };
}
