{ ... }:
{
  flake.nixosModules.syncthing-client =
    { config, ... }:
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
              id = "57MCCKJ-ZI7ZG33-5HXG7HM-4IVHZV6-JAKJNT6-PKZQUFQ-P7VYBWG-EMXOZQE";
              autoAcceptFolders = true;
            };
            "misato" = {
              id = "4TIZGOT-CPJ47IF-MDUELV4-5NOGKKY-YFPTSNQ-EDM54NG-LY2OT7T-KITLXAM";
              autoAcceptFolders = true;
            };
          };
          folders = {
            "Notes" = {
              id = "notes";
              path = "${config.my.homeDir}/Documents/Notes";
              label = "Notes";
              devices = [
                "glados"
                "misato"
              ];
            };
          };
        };
      };
    };
}
