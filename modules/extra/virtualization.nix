{ config, ... }:
{
  flake.nixosModules.virtualization =
    { pkgs, ... }:
    {
      virtualisation = {
        libvirtd = {
          enable = true;
          qemu = {
            swtpm.enable = true;
          };
        };
        spiceUSBRedirection.enable = true;
      };

      services.spice-vdagentd.enable = true;

      users.users.${config.my.username} = {
        extraGroups = [
          "libvirtd"
          "kvm"
        ];
      };

      environment.systemPackages = with pkgs; [
        _86box-with-roms
        qemu
        spice
        spice-gtk
        spice-protocol
        virt-manager
        virt-viewer
        virtio-win
        win-spice
      ];
    };
}
