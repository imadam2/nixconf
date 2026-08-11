{ config, ... }:
{
  flake.nixosModules.syncthing-client =
    { ... }:
    {
      services.syncthing = {
        enable = true;
        user = config.my.username;
        dataDir = config.my.homeDir;
        configDir = "${config.my.homeDir}/.config/syncthing";
        openDefaultPorts = true;
        settings = {
          devices = {
            "glados" = {
              id = "HWHYRLZ-HHHUPIX-TJ7ZT32-GZRQRVV-2HMP6TH-VTHSV27-Y2GEQZB-2MOYTAF";
            };
            "misato" = {
              id = "4TIZGOT-CPJ47IF-MDUELV4-5NOGKKY-YFPTSNQ-EDM54NG-LY2OT7T-KITLXAM";
            };
          };
        };
        folders = {
          "Notes" = {
            path = "${config.my.homeDir}/Documents/Notes";
            type = "sendreceive";
          };
        };
      };
    };
}
