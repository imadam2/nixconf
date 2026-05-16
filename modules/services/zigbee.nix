{ ... }:
let
  service = "zigbee";
in
{
  flake.nixosModules.${service} =
    { config, ... }:
    {
      networking.firewall = {
        allowedUDPPorts = [
          1883
        ];
        allowedTCPPorts = [
          1883
        ];
      };

      services = {
        mosquitto = {
          enable = true;
        };
        zigbee2mqtt = {
          enable = true;
          settings = {
            mqtt = {
              server = "mqtt://core-mosquitto:1883";
            };
            serial = {
              port = {
                port = "/dev/ttyUSB0";
                adapter = "ember";
                baudrate = "115200";
              };
            };
            homeassistant = {
              enabled = true;
            };
          };
        };
      };
    };
}
