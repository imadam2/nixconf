{ ... }:
{
  flake.nixosModules.git =
    { config, ... }:
    {
      programs.git = {
        enable = true;
        config = {
          user.name = config.my.gitName;
          user.email = config.my.gitEmail;
          init.defaultBranch = "master";
          core.editor = "nvim";
          pull.rebase = true;
        };
      };
    };
}
