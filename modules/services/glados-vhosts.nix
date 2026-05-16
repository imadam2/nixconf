{ ... }:
{
  flake.nixosModules.gladosVhosts =
    { config, ... }:
    let
      hl = config.homelab;
      glados = hl.gladosIP;
    in
    {
      homelab.caddy.virtualHosts = {
        "jellyfin.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:8096"
          '';
        };
        "immich.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:2283"
          '';
        };
        "prowlarr.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:9696"
          '';
        };
        "qbittorrent.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:8080"
          '';
        };
        "radarr.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:7878"
          '';
        };
        "seerr.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:5055"
          '';
        };
        "slskd.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:5030"
          '';
        };
        "sonarr.${hl.domain}" = {
          useACMEHost = hl.domain;
          extraConfig = ''
            reverse_proxy "${glados}:8989"
          '';
        };
      };
    };
}
