{ ... }:
let
  service = "caddy";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      networking.firewall.allowedUDPPorts = [
        80
        443
      ];

      services = {
        ${service} = {
          enable = true;
          user = "${hl.acme.user}";
          group = "${hl.acme.group}";
        };
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "cf@adamlucas.co.uk"; # :)
        certs."${hl.domain}" = {
          group = "${hl.acme.group}";
          domain = "${hl.domain}";
          extraDomainNames = [ "*.${hl.domain}" ];
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          dnsPropagationCheck = true;
          environmentFile = config.sops.secrets.cloudflare_api.path;
        };
      };
    };
}
