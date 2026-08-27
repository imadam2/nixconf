{ self, inputs, ... }:
{
  flake.nixosModules.mangowm =
    { pkgs, ... }:
    {
      imports = [
        inputs.mangowm.nixosModules.mango
      ];
      programs.mango = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.myMango;
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

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.myMango = inputs.wrapper-modules.wrappers.mangowc.wrap {
        inherit pkgs;
        autostart_sh = ''
          noctalia &
          prismlauncher &
          steam &
          zen-beta &
        '';

        configFile.content = ''
          repeat_rate=50
          repeat_delay=300
          blur=1
          blur_optimized=1
          gappih=0
          gappiv=0
          gappoh=0
          gappov=0
          xkb_rules_layout=gb
          xkb_rules_options=ctrl:nocaps
          disable_trackpad=1

          monitorrule=name:DP-1,width:3840,height:2160,refresh:160,x:0,y:1440
          monitorrule=name:DP-2,width:3440,height:1440,refresh:165,x:200,y:0
          monitorrule=name:HDMI-A-1,width:1600,height:1200,refresh:60,1

          mousebind=SUPER,btn_left,moveresize,curmove
          mousebind=SUPER,btn_right,moveresize,curresize

          tagrule=id:*,monitor_name:DP-1,layout_name:dwindle
          tagrule=id:*,monitor_name:DP-2,layout_name:tile

          windowrule=title:mpv,isfloating:1
          windowrule=appid:imv,isfloating:1
          windowrule=title:waywall,isfloating:1
          windowrule=title:.*[Mm]inecraft.*,isfloating:1
          windowrule=title:.*[Ll]unar.*,isfloating:1
          windowrule=appid:org-prismlauncher-EntryPoint,isfloating:1
          windowrule=title:Open File,isfloating:1
          windowrule=title:Select a File,isfloating:1
          windowrule=title:Choose Wallpaper,isfloating:1
          windowrule=title:Save As,isfloating:1
          windowrule=title:Library,isfloating:1
          windowrule=title:File Upload,isfloating:1

          windowrule=appid:vesktop,tags:1
          windowrule=appid:zen-beta,tags:2
          windowrule=appid:steam,tags:3
          windowrule=appid:org.prismlauncher.PrismLauncher,tags:3
          windowrule=appid:lunarclient,tags:3

          bind=NONE,XF86AudioMute,spawn,noctalia msg volume-mute
          bind=NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up
          bind=NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down
          bind=NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up
          bind=NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down

          bind=NONE,XF86AudioNext,spawn,noctalia msg media next
          bind=NONE,XF86AudioPrev,spawn,noctalia msg media previous
          bind=NONE,XF86AudioPlay,spawn,noctalia msg media toggle
          bind=NONE,XF86AudioPause,spawn,noctalia msg media stop

          bind=SUPER,1,view,1
          bind=SUPER,2,view,2
          bind=SUPER,3,view,3
          bind=SUPER,4,view,4
          bind=SUPER,5,view,5
          bind=SUPER,6,view,6
          bind=SUPER,7,view,7
          bind=SUPER,8,view,8
          bind=SUPER,9,view,9

          bind=SUPER+SHIFT,1,tag,1
          bind=SUPER+SHIFT,2,tag,2
          bind=SUPER+SHIFT,3,tag,3
          bind=SUPER+SHIFT,4,tag,4
          bind=SUPER+SHIFT,5,tag,5
          bind=SUPER+SHIFT,6,tag,6
          bind=SUPER+SHIFT,7,tag,7
          bind=SUPER+SHIFT,8,tag,8
          bind=SUPER+SHIFT,9,tag,9

          bind=SUPER,Q,killclient
          bind=SUPER,F,togglefullscreen
          bind=SUPER,S,toggleglobal

          bind=SUPER,H,resizewin,-100,0
          bind=SUPER,J,focusdir,left
          bind=SUPER,K,focusdir,right
          bind=SUPER,L,resizewin,+100,0

          bind=SUPER+SHIFT,H,exchange_client,left
          bind=SUPER+SHIFT,J,exchange_client,down
          bind=SUPER+SHIFT,K,exchange_client,up
          bind=SUPER+SHIFT,L,exchange_client,right

          bind=SUPER+CTRL,J,focusdir,down
          bind=SUPER+CTRL,k,focusdir,up

          bind=SUPER+SHIFT,SPACE,togglefloating
          bind=SUPER,BACKSPACE,spawn,noctalia msg session lock

          bind=SUPER,W,spawn,zen-beta
          bind=SUPER,E,spawn,noctalia msg panel-toggle launcher /emo
          bind=SUPER+SHIFT,R,spawn,thunar
          bind=SUPER+SHIFT,E,reload_config
          bind=SUPER,R,spawn,kitty -e yazi
          bind=SUPER,A,spawn,noctalia msg bar-toggle
          bind=SUPER,D,spawn,noctalia msg panel-toggle launcher
          bind=SUPER,V,spawn,noctalia msg panel-toggle clipboard
          bind=SUPER,M,spawn,kitty -e jellyfin-tui
          bind=SUPER,Return,spawn,kitty

          bind=NONE,Print,spawn,screenshot area
          bind=SUPER,Print,spawn,screenshot window
          bind=SHIFT,Print,spawn,screenshot display
          bind=CTRL,Print,spawn,screenshot area-s
          bind=CTRL+SUPER,Print,spawn,screenshot window-s
          bind=CTRL+SHIFT,Print,spawn,screenshot display-s
        '';
      };
    };
}
