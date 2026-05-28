{ ... }:
let
  service = "slskd";
  port = 5030;
  ports = 5031;
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [
          port
          ports
        ];
        allowedTCPPorts = [
          port
          ports
        ];
      };

      services = {
        ${service} = {
          enable = true;
          domain = "${service}.${hl.domain}";
          user = hl.user;
          group = hl.group;
          environmentFile = "${config.sops.secrets.slskd.path}";
          settings = {
            shares.directories = [
              "${hl.mediaDir}/Music/share"
            ];
            directories.downloads = "${hl.mediaDir}/Music/downloads";
          };
          nginx.listen = [
            {
              addr = "10.1.10.3";
              port = 4343;
              ssl = true;
            }
            {
              addr = "10.1.10.3";
              port = 1488;
            }
          ];
        };
      };
    };
}
