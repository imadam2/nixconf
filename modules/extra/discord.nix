{ ... }:
{
  flake.homeModules.discord =
    { ... }:
    {
      programs.equibop = {
        enable = true;
        settings = {
          arRPC = true;
          discordBranch = "canary";
        };
      };
    };
}
