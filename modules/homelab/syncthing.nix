{ ... }:
let
  service = "syncthing";
  port = 8384;
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    let
      hl = config.homelab;
    in
    {
      systemd.tmpfiles.rules = [
        "d ${hl.storageDir}/Notes 0775 ${hl.user} ${hl.group} - -"
      ];

      networking.firewall = {
        allowedUDPPorts = [
          port
        ];
        allowedTCPPorts = [
          port
        ];
      };

      services.syncthing = {
        enable = true;
        user = hl.user;
        dataDir = "${hl.appdataDir}/${service}";
        configDir = "${hl.appdataDir}/${service}/config";
        guiAddress = "10.1.10.3:${toString port}";
        openDefaultPorts = true;

        settings = {
          devices = {
            "mayuri" = {
              id = "LUWLTCC-GRPZW7H-OQWX6AU-ZCFFFO6-HWH6FTC-PIIZITI-YPT4MNQ-GCSLCAG";
            };
            "misato" = {
              id = "4TIZGOT-CPJ47IF-MDUELV4-5NOGKKY-YFPTSNQ-EDM54NG-LY2OT7T-KITLXAM";
            };
          };
          options = {
            globalAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          folders = {
            notes = {
              path = "${hl.storageDir}/Notes";
              label = "Notes";
              type = "sendreceive";
            };
          };
        };
      };
    };
}
