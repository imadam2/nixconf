{ ... }:
{
  flake.homeModules.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        evtest
        grim
        orca-slicer
        pavucontrol
        qbittorrent
        satty
        signal-desktop
        slurp
        thunar
        vial
        wl-clipboard
      ];
    };
}
