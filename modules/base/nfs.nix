{ ... }:
{
  flake.nixosModules.nfs =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ nfs-utils ];
      services.rpcbind.enable = true;

      boot = {
        supportedFilesystems = [
          "nfs"
          "nfs4"
        ];
        kernelModules = [
          "nfs"
          "nfs4"
        ];
      };

      fileSystems."/media/NAS" = {
        device = "10.1.10.3:/";
        fsType = "nfs4";
        options = [
          "nfsvers=4.2"
          "noatime"
          "rsize=65536"
          "wsize=65536"
        ];
      };

      systemd.automounts = [
        {
          where = "/media/NAS";
          wantedBy = [ "multi-user.target" ];
          automountConfig = {
            TimeoutIdleSec = "300";
            DirectoryMode = "0755";
          };
        }
      ];
    };
}
