{ ... }:
{
  flake.nixosModules.audio =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        pamixer
        pavucontrol
        easyeffects
      ];
      services.pipewire = {
        enable = true;
        pulse.enable = true;
        jack.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
      };
    };
}
