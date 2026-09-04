{ self, inputs, ... }:
let
  hostname = baseNameOf ./.;
in
{
  flake.nixosConfigurations."${hostname}" = inputs.nixpkgs.lib.nixosSystem {

    modules = with self.nixosModules; [
      profileDesktop
      profileLaptop
      self.nixosModules."${hostname}Configuration"
      self.nixosModules."${hostname}Hardware"
      self.nixosModules."${hostname}Disko"
      inputs.disko.nixosModules.disko
      homeManager
      {
        home-manager.users.ye.imports = with self.homeModules; [
          profileDesktop
        ];
      }
    ];
  };

  flake.nixosModules."${hostname}Configuration" =
    { ... }:
    {
      networking.hostName = "${hostname}";
    };
}
