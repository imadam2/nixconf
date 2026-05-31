# nixconf

# my nixos config using flake-parts and the dendritic pattern

## hosts

| host    | description        |
| ------- | ------------------ |
| atlas   | Ryzen Main Desktop |
| beast   | Dual CPU HP Z620   |
| chell   | ThinkCentre M93p   |
| glados  | i5-12500 NAS       |
| heavy   | ThinkPad W520      |
| unit-00 | ThinkPad X230 #1   |
| unit-01 | ThinkPad X230 #2   |
| vm      | generic vm host    |

---

## services

| component    | name                            |
| ------------ | ------------------------------- |
| wm           | hyprland                        |
| bar          | noctalia v5                     |
| terminal     | foot                            |
| browser      | zen                             |
| editor       | neovim                          |
| shell        | fish                            |
| file manager | yazi                            |
| theming      | catppuccin mocha, jetbrainsmono |

## homelab

### chell

| Icon                                                                                                 | Name             | Description                      | Category |
| ---------------------------------------------------------------------------------------------------- | ---------------- | -------------------------------- | -------- |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/adguard-home.svg' width=32 height=32>   | AdGuard Home     | DNS Adblocker                    | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/caddy.svg' width=32 height=32>          | Caddy            | Reverse Proxy                    | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/glance.svg' width=32 height=32>         | Glance           | Landing page                     | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/home-assistant.svg' width=32 height=32> | Home Assistant   | Home automation                  | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/unbound.svg' width=32 height=32>        | Unbound          | DNS Resolver                     | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/uptime-kuma.svg' width=32 height=32>    | Uptime Kuma      | Tells me if things are broken    | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/ubiuqiti-unifi.svg' width=32 height=32> | Unifi Controller | Controller for ubiuqiti products | Services |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/vaultwarden.svg' width=32 height=32>    | Vaultwarden      | Password manager                 | Services |

### glados

| Icon                                                                                               | Name         | Description                                     | Category  |
| -------------------------------------------------------------------------------------------------- | ------------ | ----------------------------------------------- | --------- |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/flaresolverr.svg' width=32 height=32> | Flaresolverr | Solves cloudflare captchas                      | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/immich.svg' width=32 height=32>       | Immich       | Self-hosted photo and video management solution | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/jellyfin.svg' width=32 height=32>     | Jellyfin     | The Free Software Media System                  | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/prowlarr.svg' width=32 height=32>     | Prowlarr     | PVR indexer                                     | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/qbittorrent.svg' width=32 height=32>  | qBittorrent  | Torrent client                                  | Downloads |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/radarr.svg' width=32 height=32>       | Radarr       | Movie collection manager                        | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/seerr.svg' width=32 height=32>        | Seerr        | Media request and discovery manager             | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/slskd.svg' width=32 height=32>        | Slskd        | Web-based Soulseek client                       | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/sonarr.svg' width=32 height=32>       | Sonarr       | TV show collection manager                      | Media     |
| <img src='https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/syncthing.svg' width=32 height=32>    | Syncthing    | Syncs things                                    | Services  |

## wallpapers

\_hr in filename means its >4K (high res)

\_uw in filename means its ultrawide

\_up in filename means its upscaled
