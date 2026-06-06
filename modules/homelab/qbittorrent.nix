{ ... }:
let
  service = "qbittorrent";
  port = 8080;
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
        ];
        allowedTCPPorts = [
          port
        ];
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
                AddTorrentStopped = false;
                BTProtocol = "TCP";
                DHTEnabled = false;
                DsableAutoTMMByDefault = false;
                LSDEnabled = false;
                GlobalUPSpeedLimit = "0";
                MaxActiveDownloads = "10";
                MaxActiveTorrents = "20";
                MaxActiveUploads = "20";
                MaxConnections = "800";
                MaxConnectionsPerTorrent = "200";
                MaxUploads = "100";
                MaxUploadsPerTorrent = "20";
                PeXEnabled = false;
                Port = "50000";
                QueueingSystemEnabled = false;
                uTPMixedMode = "Proportional";
                uTPRateLimited = true;
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
