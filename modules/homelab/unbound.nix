{ ... }:
let
  port = 5335;
in
{
  flake.nixosModules.unbound =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          port
        ];
        allowedTCPPorts = [
          port
        ];
      };

      services = {
        unbound = {
          enable = true;
          settings = {
            server = {
              interface = [
                "127.0.0.1"
                "::1"
              ];
              port = port;
              access-control = [
                "127.0.0.0/8 allow"
                "::1/128 allow"
              ];
              local-zone = "\"${hl.domain}.\" transparent";

              do-ip4 = true;
              do-ip6 = false;
              prefetch = true;
              num-threads = 2;
            };
            forward-zone = [
              {
                name = ".";
                forward-addr = [
                  "1.1.1.1@853#cloudflare-dns.com"
                  "1.0.0.1@853#cloudflare-dns.com"
                ];
                forward-tls-upstream = true;
              }
            ];
          };
        };
      };
    };
}
