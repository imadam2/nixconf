{ lib, ... }:
{
  flake.nixosModules.caddyVhosts =
    { config, ... }:
    let
      hl = config.homelab;
      glados = hl.gladosIP;

      # Map subdomains to local ports on glados
      simpleProxies = {
        jellyfin = 8096;
        immich = 2283;
        prowlarr = 9696;
        qbittorrent = 8080;
        radarr = 7878;
        seerr = 5055;
        slskd = 5030;
        syncthing = 8384;
        sonarr = 8989;
      };
    in
    {
      homelab.caddy.virtualHosts =
        (lib.mapAttrs' (name: port: {
          name = "${name}.${hl.domain}";
          value = {
            useACMEHost = hl.domain;
            extraConfig = "reverse_proxy \"${glados}:${toString port}\"";
          };
        }) simpleProxies)
        // {
          "opnsense.${hl.domain}" = {
            useACMEHost = hl.domain;
            extraConfig = "reverse_proxy \"https://10.1.10.1:443\"";
          };
          "proxmox.${hl.domain}" = {
            useACMEHost = hl.domain;
            extraConfig = ''
              reverse_proxy https://10.1.10.2:8006 {
                transport http {
                  tls_insecure_skip_verify
                }
              }
            '';
          };
        };
    };
}
