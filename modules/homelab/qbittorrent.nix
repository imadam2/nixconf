{ ... }:
let
  service = "qbittorrent";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      networking.firewall = {
        allowedUDPPorts = [ 8080 ];
        allowedTCPPorts = [ 8080 ];
      };

      services = {
        ${service} = {
          enable = true;
          user = "${hl.user}";
          group = "${hl.group}";
          profileDir = "${hl.appdataDir}/${service}";
          serverConfig = {
            LegalNotice.Accepted = true;
            BitTorrent = {
              Session = {
                GlobalUPSpeedLimit = "9000";
                MaxActiveDownloads = "10";
                MaxActiveTorrents = "20";
                MaxActiveUploads = "20";
                MaxConnections = "800";
                MaxConnectionsPerTorrent = "200";
                MaxUploadsPerTorrent = "30";
                uTPRateLimited = false;
              };
            };
            Preferences = {
              General.Locale = "en";
              User = hl.user;
              Group = hl.group;
              Downloads = {
                SavePath = "${hl.mediaDir}/torrents";
              };
              WebUI = {
                Username = "adam";
                Password_PBKDF2 = "@ByteArray(yY2ev2x39V1reCALLZCK1Q==:zA73cEWzLqZAmeJAZY+It0bYOAHK8Cjdk7LYs1wtvQo39855fSMIRSwYawFwPRwb7zO+CVU5tG0vYivYAVcGIw==)";
                ServerDomains = "${hl.domain}";
              };
            };
          };
        };
      };
    };
}
