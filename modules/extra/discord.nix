{ ... }:
{
  flake.homeModules.discord =
    { ... }:
    {
      programs.vesktop = {
        enable = true;
        settings = {
          arRPC = true;
          discordBranch = "canary";
        };
      };
    };
}
