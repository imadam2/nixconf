{ ... }:
let
  service = "immich";
in
{
  flake.nixosModules.${service} =
    { config, pkgs, ... }:
    let
      hl = config.homelab;
    in
    {
      systemd.tmpfiles.rules = [ "d ${hl.mediaDir}/${service} 0775 immich ${hl.group} - -" ];

      users.users."${service}".extraGroups = [
        "video"
        "render"
      ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
        ];
      };

      services = {
        ${service} = {
          enable = true;
          group = hl.group;
          host = "0.0.0.0";
          openFirewall = true;
          mediaLocation = "${hl.mediaDir}/${service}/photos";
          accelerationDevices = [
            "/dev/dri/renderD128"
          ];
        };
      };
    };
}
