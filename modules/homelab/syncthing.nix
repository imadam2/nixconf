{ ... }:
let
  service = "syncthing";
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

      services.syncthing = {
        enable = true;
        user = hl.user;
        dataDir = "${hl.storageDir}/Notes";
        configDir = "${hl.configDir}/${service}";
        openDefaultPorts = true;

        settings = {
          options = {
            globalAnnounceEnabled = true;
            relaysEnabled = true;
            urAccepted = -1;
          };

          devices = {
            desktop = {
              id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
              name = "Desktop";
            };
            phone = {
              id = "YYYYYYY-YYYYYYY-YYYYYYY-YYYYYYY-YYYYYYY-YYYYYYY-YYYYYYY-YYYYYYY";
              name = "Phone";
            };
          };

          folders = {
            notes = {
              path = "${hl.storageDir}/Notes";
              label = "Notes";
              devices = [
                "desktop"
                "phone"
              ];
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
