{ inputs, ... }:
{
  flake.nixosModules.mangowm =
    { pkgs, ... }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];
      programs.mango = {
        enable = true;
      };
      xdg.portal = {
        enable = true;
        wlr = {
          enable = true;
          settings = {
            screencast = {
              chooser_type = "dmenu";
              chooser_cmd = "/etc/profiles/per-user/ye/bin/noctalia dmenu -p 'Select Screen'";
              max_fps = "60";
              force_mod_linear = true;
            };
          };
        };
        config = {
          mango = {
            default = [ "gtk" ];
            "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
            "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          };
        };
        extraPortals = [
          pkgs.xdg-desktop-portal-wlr
          pkgs.xdg-desktop-portal-gtk
        ];
        config = {
          common = {
            default = [
              "wlr"
              "gtk"
            ];
          };
        };
      };
    };

  flake.homeModules.mangowm =
    { ... }:
    {
      imports = [
        inputs.mangowm.hmModules.mango
      ];

      wayland.windowManager.mango = {
        enable = true;
        systemd.enable = true;
        autostart_sh = ''
          noctalia &
          prismlauncher &
          steam &
          zen-beta &
        '';
        settings = {
          repeat_rate = 50;
          repeat_delay = 300;
          blur = 1;
          blur_optimized = 1;
          gappih = 0;
          gappiv = 0;
          gappoh = 0;
          gappov = 0;
          xkb_rules_layout = "gb";
          xkb_rules_options = "ctrl:nocaps";

          devicerule = [
            "name:Endgame Gear Endgame Gear HS Dongle,accel_profile:1"
          ];

          monitorrule = [
            "name:DP-1,width:3840,height:2160,refresh:160,x:0,y:1440"
            "name:DP-2,width:3440,height:1440,refresh:165,x:200,y:0"
            "name:HDMI-A-1,width:1600,height:1200,refresh:60,1"
          ];
          blur_params = {
            radius = 5;
            num_passes = 2;
          };

          mousebind = [
            "SUPER,btn_left,moveresize,curmove"
            "SUPER,btn_right,moveresize,curresize"
          ];

          tagrule = [
            "id:*,monitor_name:DP-1,layout_name:dwindle"
            "id:*,monitor_name:DP-2,layout_name:tile"
          ];

          windowrule = [
            "title:mpv,isfloating:1"
            "appid:imv,isfloating:1"
            "title:waywall,isfloating:1"
            "title:.*[Mm]inecraft.*,isfloating:1"
            "title:.*[Ll]unar.*,isfloating:1"
            "appid:org-prismlauncher-EntryPoint,isfloating:1"
            "title:Open File,isfloating:1"
            "title:Select a File,isfloating:1"
            "title:Choose Wallpaper,isfloating:1"
            "title:Save As,isfloating:1"
            "title:Library,isfloating:1"
            "title:File Upload,isfloating:1"

            "appid:vesktop,tags:1"
            "appid:zen-beta,tags:2"
            "appid:steam,tags:3"
            "appid:org.prismlauncher.PrismLauncher,tags:3"
            "appid:lunarclient,tags:3"
          ];

          bind = [
            "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
            "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
            "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
            "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
            "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"

            "NONE,XF86AudioNext,spawn,noctalia msg media next"
            "NONE,XF86AudioPrev,spawn,noctalia msg media previous"
            "NONE,XF86AudioPlay,spawn,noctalia msg media toggle"
            "NONE,XF86AudioPause,spawn,noctalia msg media stop"

            "SUPER,1,view,1"
            "SUPER,2,view,2"
            "SUPER,3,view,3"
            "SUPER,4,view,4"
            "SUPER,5,view,5"
            "SUPER,6,view,6"
            "SUPER,7,view,7"
            "SUPER,8,view,8"
            "SUPER,9,view,9"

            "SUPER+SHIFT,1,tag,1"
            "SUPER+SHIFT,2,tag,2"
            "SUPER+SHIFT,3,tag,3"
            "SUPER+SHIFT,4,tag,4"
            "SUPER+SHIFT,5,tag,5"
            "SUPER+SHIFT,6,tag,6"
            "SUPER+SHIFT,7,tag,7"
            "SUPER+SHIFT,8,tag,8"
            "SUPER+SHIFT,9,tag,9"

            "SUPER,Q,killclient"
            "SUPER,F,togglefullscreen"
            "SUPER,S,toggleglobal"

            "SUPER,H,resizewin,-100,0"
            "SUPER,J,focusdir,left"
            "SUPER,K,focusdir,right"
            "SUPER,L,resizewin,+100,0"

            "SUPER+SHIFT,H,exchange_client,left"
            "SUPER+SHIFT,J,exchange_client,down"
            "SUPER+SHIFT,K,exchange_client,up"
            "SUPER+SHIFT,L,exchange_client,right"

            "SUPER+CTRL,J,focusdir,down"
            "SUPER+CTRL,k,focusdir,up"

            "SUPER+SHIFT,SPACE,togglefloating"
            "SUPER,BACKSPACE,spawn,noctalia msg session lock"

            "SUPER,W,spawn,zen-beta"
            "SUPER,E,spawn,noctalia msg panel-toggle launcher /emo"
            "SUPER+SHIFT,R,spawn,thunar"
            "SUPER+SHIFT,E,reload_config"
            "SUPER,R,spawn,kitty -e yazi"
            "SUPER,A,spawn,noctalia msg bar-toggle"
            "SUPER,D,spawn,noctalia msg panel-toggle launcher"
            "SUPER,V,spawn,noctalia msg panel-toggle clipboard"
            "SUPER,M,spawn,kitty -e jellyfin-tui"
            "SUPER,Return,spawn,kitty"

            "NONE,Print,spawn,screenshot area"
            "SUPER,Print,spawn,screenshot window"
            "SHIFT,Print,spawn,screenshot display"
            "CTRL,Print,spawn,screenshot area-s"
            "CTRL+SUPER,Print,spawn,screenshot window-s"
            "CTRL+SHIFT,Print,spawn,screenshot display-s"
          ];
        };
      };
    };
}
