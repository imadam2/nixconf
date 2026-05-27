{ ... }:
let
  service = "homepage";
in
{
  flake.nixosModules.${service} =
    { config, lib, ... }:
    let
      hl = config.homelab;
    in
    {
      services.glance = {
        enable = true;
        openFirewall = true;

        settings = {
          server = {
            host = "0.0.0.0";
            port = 8090;
          };

          theme = {
            background-color = "240 8 9";
            primary-color = "217 92 83";
            positive-color = "115 54 76";
            negative-color = "347 70 65";
          };

          pages = [
            {
              name = "Home";
              columns = [
                {
                  size = "small";
                  widgets = [
                    {
                      type = "clock";
                      hour-format = "24h";
                    }
                    {
                      type = "calendar";
                    }
                    {
                      type = "monitor";
                      title = "Network";
                      sites = [
                        {
                          title = "AdGuard Home";
                          url = "http://localhost:3000";
                          icon = "si:adguard";
                        }
                        {
                          title = "Unbound";
                          url = "http://localhost:8953";
                          icon = "si:cloudflare";
                        }
                        {
                          title = "UniFi";
                          url = "https://localhost:8443";
                          icon = "si:ubiquiti";
                        }
                        {
                          title = "Caddy";
                          url = "http://localhost:2019/metrics";
                          icon = "si:caddy";
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "full";
                  widgets = [
                    {
                      type = "monitor";
                      title = "Media";
                      sites = [
                        {
                          title = "Jellyfin";
                          url = "http://localhost:8096";
                          icon = "si:jellyfin";
                        }
                        {
                          title = "Immich";
                          url = "http://localhost:2283";
                          icon = "si:immich";
                        }
                        {
                          title = "Seerr (Jellyseerr)";
                          url = "http://localhost:5055";
                          icon = "si:jellyseerr";
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      title = "Download Stack";
                      sites = [
                        {
                          title = "Radarr";
                          url = "http://localhost:7878";
                          icon = "si:radarr";
                        }
                        {
                          title = "Sonarr";
                          url = "http://localhost:8989";
                          icon = "si:sonarr";
                        }
                        {
                          title = "Prowlarr";
                          url = "http://localhost:9696";
                          icon = "si:prowlarr";
                        }
                        {
                          title = "qBittorrent";
                          url = "http://localhost:8080";
                          icon = "si:qbittorrent";
                        }
                        {
                          title = "FlareSolverr";
                          url = "http://localhost:8191";
                          icon = "di:docker";
                        }
                        {
                          title = "Slskd";
                          url = "http://localhost:5030";
                          icon = "di:docker";
                        }
                      ];
                    }
                    {
                      type = "monitor";
                      title = "Home & Self-Hosted";
                      sites = [
                        {
                          title = "Home Assistant";
                          url = "http://localhost:8123";
                          icon = "si:homeassistant";
                        }
                        {
                          title = "Zigbee2MQTT";
                          url = "http://localhost:8080";
                          icon = "si:zigbee";
                        }
                        {
                          title = "Vaultwarden";
                          url = "http://localhost:8222";
                          icon = "si:vaultwarden";
                        }
                        {
                          title = "Homepage";
                          url = "http://localhost:3000";
                          icon = "si:homepage";
                        }
                        {
                          title = "Uptime Kuma";
                          url = "http://localhost:3001";
                          icon = "si:uptimekuma";
                        }
                      ];
                    }
                  ];
                }
                {
                  size = "small";
                  widgets = [
                    {
                      type = "monitor";
                      title = "Status";
                      sites = [
                        {
                          title = "Uptime Kuma";
                          url = "http://localhost:3001";
                          icon = "si:uptimekuma";
                        }
                      ];
                    }
                    {
                      type = "releases";
                      title = "NixOS Updates";
                      repositories = [
                        "NixOS/nixpkgs"
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
}
