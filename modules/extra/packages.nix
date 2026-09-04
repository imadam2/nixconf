{ ... }:
{
  flake.homeModules.packages =
    { pkgs, ... }:
    {
      xdg.configFile."Vial/Vial.conf".text = ''
        [General]
        theme=Catppuccin Mocha
      '';

      home.packages = with pkgs; [
        evtest
        grim
        just
        nixos-anywhere
        orca-slicer
        pavucontrol
        qbittorrent
        satty
        signal-desktop
        slurp
        ssh-to-age
        thunar
        vial
        wl-clipboard
      ];
    };
}
