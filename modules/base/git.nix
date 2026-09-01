{ ... }:
{
  flake.nixosModules.git =
    { config, ... }:
    {
      programs.git = {
        enable = true;
        config = {
          init.defaultBranch = "master";
          core.editor = "nvim";
          pull.rebase = true;
          user = {
            name = config.my.gitName;
            email = config.my.gitEmail;
          };
        };
      };
    };
}
