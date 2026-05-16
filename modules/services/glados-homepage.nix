{ ... }:
{
  flake.nixosModules.gladosHomepage =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      homelab.homepage.cfg = {
        Media = [
          {
            "Jellyfin" = {
              description = "Media Player";
              href = "https://jellyfin.${hl.domain}";
              icon = "sh-jellyfin.svg";
            };
          }
          {
            "Prowlarr" = {
              description = "Torrent Site Indexer";
              href = "https://prowlarr.${hl.domain}";
              icon = "sh-prowlarr.svg";
            };
          }
          {
            "qBittorrent" = {
              description = "Torrent Client";
              href = "https://qbittorrent.${hl.domain}";
              icon = "sh-qbittorrent.svg";
            };
          }
          {
            "Radarr" = {
              description = "Movie Torrent Indexer";
              href = "https://radarr.${hl.domain}";
              icon = "sh-radarr.svg";
            };
          }
          {
            "Seerr" = {
              description = "Easy *arr UI";
              href = "https://seerr.${hl.domain}";
              icon = "sh-seerr.svg";
            };
          }
          {
            "Slskd" = {
              description = "SoulSeek WebUI";
              href = "https://slskd.${hl.domain}";
              icon = "sh-slskd.svg";
            };
          }
          {
            "Sonarr" = {
              description = "TV Show Torrent Indexer";
              href = "https://sonarr.${hl.domain}";
              icon = "sh-sonarr.svg";
            };
          }
        ];
        Cloud = [
          {
            "Immich" = {
              description = "Photo Library";
              href = "https://immich.${hl.domain}";
              icon = "sh-immich.svg";
            };
          }
        ];
      };
    };
}
