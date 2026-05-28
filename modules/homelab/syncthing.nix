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
        dataDir = "${hl.storageDir}/Notes";
        configDir = "${hl.appdataDir}/${service}";
        guiAddress = "10.1.10.3:${toString port}";
        openDefaultPorts = true;

        settings = {
          options = {
            globalAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          folders = {
            notes = {
              path = "${hl.storageDir}/Notes";
              label = "Notes";
              versioning = {
                type = "trashcan";
                params.cleanoutDays = "30";
              };
            };
          };
        };
      };
    };
}
