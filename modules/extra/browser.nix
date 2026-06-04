{ inputs, ... }:
{
  flake.homeModules.browser =
    { pkgs, ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      stylix.targets.zen-browser.profileNames = [ "default" ];

      programs.zen-browser = {
        enable = true;
        #nativeMessagingHosts = [ pkgs.firefoxpwa ];
        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
        };
        profiles.default = {
          pinsForce = true;
          spacesForce = true;
          containersForce = true;
          mods = [
            "181e41d4-dfd3-410d-9a73-561381a2f77d"
            "a6335949-4465-4b71-926c-4a52d34bc9c0"
            "c5f7fb68-cc75-4df0-8b02-dc9ee13aa773"
            "c6813222-6571-4ba6-8faf-58f3343324f6"
            "c8d9e6e6-e702-4e15-8972-3596e57cf398"
          ];
          settings = {
            "zen.view.compact.enable-at-startup" = true;
            "zen.view.compact.hide-tabbar" = false;
            "zen.view.compact.hide-toolbar" = true;
            "zen.view.compact.should-enable-at-startup" = false;
            "zen.view.sidebar-expanded" = false;
            "zen.view.use-single-toolbar" = false;
            "zen.welcome-screen.seen" = true;
            "extensions.autoDisableScopes" = false;
          };
          pins = {
            "Glance" = {
              url = "https://glance.tjd.lol";
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
              position = 101;
              isEssential = true;
            };
            "X" = {
              url = "https://x.com";
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
              position = 102;
              isEssential = true;
            };
            "YouTube" = {
              url = "https://youtube.com";
              id = "9d8a8f91-7e29-4688-ae2e-da4e49d4a179";
              position = 103;
              isEssential = true;
            };
          };

          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              bitwarden
              tridactyl
              stylus
              sponsorblock
            ];
          };
          search = {
            force = true;
            default = "google";
            engines = {
              google = {
                name = "google";
                urls = [
                  {
                    template = "https://google.com/search?q={searchTerms}";
                    params = [
                    ];
                  }
                ];
              };
            };
          };
        };
      };
    };
}
