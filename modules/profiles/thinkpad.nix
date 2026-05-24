{ ... }:
{
  flake.nixosModules.profileLaptop =
    { config, ... }:
    {
      imports = [ ]; # profileDesktop gets imported in the host itself

      boot = {
        kernelModules = [
          "acpi_call"
          "tp_smapi"
        ];
        extraModulePackages = with config.boot.kernelPackages; [
          acpi_call
          tp_smapi
        ];
        kernelParams = [
          "pcie_aspm=off"
          "i915.enable_rc6=1"
          "i915.enable_fbc=1"
        ];
      };

      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
        powertop.enable = true;
      };

      services = {
        thermald.enable = true;
        fprintd.enable = true;
        tlp = {
          enable = true;
          settings = {
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 85;
          };
        };
      };

      nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
    };
}
