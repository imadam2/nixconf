{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      profileDesktop
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      self.nixosModules."${hostname}Disko"
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          discord
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    { pkgs, ... }:
    {
      networking.hostName = "${hostname}";

      services.throttled.enable = true;
      services.fprintd.enable = true;
      security.pam.services.login.fprintAuth = true;
      security.pam.services.sudo.fprintAuth = true;

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
        ];
      };

      boot = {
        kernelParams = [
          "i915.enable_psr=0"
        ];
        kernelModules = [
          "thinkpad_acpi"
        ];
        extraModprobeConfig = ''
          options thinkpad_acpi fan_control=1
        '';
      };

      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

          # Stop battery charging at 80% to preserve battery health
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;

          RUNTIME_PM_ON_AC = "auto";
          RUNTIME_PM_ON_BAT = "auto";

          WIFI_PWR_ON_AC = "off";
          WIFI_PWR_ON_BAT = "on";
        };
      };
    };
}
