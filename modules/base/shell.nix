{ ... }:
{
  flake.nixosModules.shell =
    { pkgs, ... }:
    {
      programs.fish.enable = true;

      environment.systemPackages = with pkgs; [
        btop
        eza
        fd
        fuse
        glib
        gvfs
        jq
        ripgrep
      ];
    };

  flake.homeModules.shell =
    { lib, pkgs, ... }:
    {
      programs = {
        bat.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        fzf = {
          enable = true;
          enableFishIntegration = true;
        };

        btop = {
          enable = true;
          settings = {
            theme_background = false;
            rounded_corners = false;
            cpu_bottom = true;
            mem_below_net = true;
            vim_keys = true;
          };
        };

        yazi = {
          package = (pkgs.yazi.override { _7zz = pkgs._7zz-rar; });
          enable = true;
          enableFishIntegration = true;
          shellWrapperName = "y";
          plugins = with pkgs.yaziPlugins; {
            compress.package = compress;
            convert.package = convert;
            gvfs.package = gvfs;
            zoom.package = zoom;
          };
          theme = {
            indicator = {
              padding = {
                open = "█";
                close = "█";
              };
            };
          };
          settings = {
            manager = {
              linemode = "size";
              show_symlink = true;
              sort_by = "natural";
              sort_dir_first = true;
              sort_reverse = false;
              sort_sensitive = false;
            };
          };
          keymap.mgr.prepend_keymap = [
            {
              run = "plugin gvfs -- select-then-mount";
              on = [
                "M"
                "m"
              ];
            }
            {
              on = [
                "M"
                "m"
              ];
              run = "plugin gvfs -- select-then-mount --jump";
              desc = "Select device to mount and jump to its mount point";
            }
            {
              on = [
                "M"
                "R"
              ];
              run = "plugin gvfs -- remount-current-cwd-device";
              desc = "Remount device under cwd";
            }
            {
              on = [
                "M"
                "u"
              ];
              run = "plugin gvfs -- select-then-unmount";
              desc = "Select device then unmount";
            }
            {
              on = [
                "M"
                "U"
              ];
              run = "plugin gvfs -- select-then-unmount --eject";
              desc = "Select device then eject";
            }
            {
              on = [
                "M"
                "U"
              ];
              run = "plugin gvfs -- select-then-unmount --eject --force";
              desc = "Select device then force to eject/unmount";
            }
            {
              on = [
                "M"
                "a"
              ];
              run = "plugin gvfs -- add-mount";
              desc = "Add a GVFS mount URI";
            }
            {
              on = [
                "M"
                "e"
              ];
              run = "plugin gvfs -- edit-mount";
              desc = "Edit a GVFS mount URI";
            }
            {
              on = [
                "M"
                "r"
              ];
              run = "plugin gvfs -- remove-mount";
              desc = "Remove a GVFS mount URI";
            }
            {
              on = [
                "g"
                "m"
              ];
              run = "plugin gvfs -- jump-to-device";
              desc = "Select device then jump to its mount point";
            }
            {
              on = [
                "g"
                "m"
              ];
              run = "plugin gvfs -- jump-to-device --automount";
              desc = "Automount then select device to jump to its mount point";
            }
            {
              on = [
                "`"
                "`"
              ];
              run = "plugin gvfs -- jump-back-prev-cwd";
              desc = "Jump back to the position before jumped to device";
            }
            {
              on = [
                "m"
                "a"
              ];
              run = [
                "plugin yamb -- save"
                "plugin gvfs -- automount-when-cd"
              ];
              desc = "Add bookmark and enable automount when cd";
            }
            {
              on = [
                "M"
                "t"
              ];
              run = "plugin gvfs -- automount-when-cd";
              desc = "Enable automount when cd to device under cwd";
            }
            {
              on = [
                "M"
                "T"
              ];
              run = "plugin gvfs -- automount-when-cd --disabled";
              desc = "Disable automount when cd to device under cwd";
            }
            {
              on = [
                "c"
                "a"
                "a"
              ];
              run = "plugin compress";
              desc = "Archive selected files";
            }
            {
              on = [
                "c"
                "a"
                "p"
              ];
              run = "plugin compress -p";
              desc = "Archive selected files (password)";
            }
            {
              on = [
                "c"
                "a"
                "h"
              ];
              run = "plugin compress -ph";
              desc = "Archive selected files (password+header)";
            }
            {
              on = [
                "c"
                "a"
                "l"
              ];
              run = "plugin compress -l";
              desc = "Archive selected files (compression level)";
            }
            {
              on = [
                "c"
                "a"
                "u"
              ];
              run = "plugin compress -phl";
              desc = "Archive selected files (password+header+level)";
            }
            {
              on = [
                "c"
                "p"
              ];
              run = "plugin convert -- --extension='png'";
              desc = "Convert selected files to PNG";
            }
            {
              on = [
                "c"
                "j"
              ];
              run = "plugin convert -- --extension='jpg'";
              desc = "Convert selected files to JPG";
            }
            {
              on = [
                "c"
                "w"
              ];
              run = "plugin convert -- --extension='webp'";
              desc = "Convert selected files to WebP";
            }
            {
              on = "+";
              run = "plugin zoom 1";
              desc = "Zoom in hovered file";
            }
            {
              on = "-";
              run = "plugin zoom -1";
              desc = "Zoom out hovered file";
            }
          ]
          ++
            lib.mapAttrsToList
              (
                dir: key:
                let
                  keys =
                    if lib.isString key then
                      [
                        "b"
                        key
                      ]
                    else
                      [ "b" ] ++ key;
                in
                {
                  on = keys;
                  run = "cd ${dir}";
                  desc = "Go to ${dir}";
                }
              )
              {
                "/media/NAS/" = [ "n" ];
                "/media/NAS/storage/Pictures/Screenshots/" = [
                  "n"
                  "s"
                ];
                "/media/NAS/storage/Videos/" = [
                  "n"
                  "v"
                ];
                "~/.local/share/Steam/steamapps/common" = [
                  "s"
                  "a"
                ];
                "~/nixconf" = [
                  "n"
                  "c"
                ];
                "~/Downloads/" = [ "d" ];
                "~/Documents/" = [ "D" ];
              };
        };
        cava = {
          enable = true;
          settings = {
            output = {
              orientation = "horizontal";
            };
            color = {
              gradient = 1;
              gradient_color_1 = "'#94e2d5'";
              gradient_color_2 = "'#89dceb'";
              gradient_color_3 = "'#74c7ec'";
              gradient_color_4 = "'#89b4fa'";
              gradient_color_5 = "'#cba6f7'";
              gradient_color_6 = "'#f5c2e7'";
              gradient_color_7 = "'#eba0ac'";
              gradient_color_8 = "'#f38ba8'";
            };
          };
        };
        fastfetch = {
          enable = true;
          settings = {
            "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
            #logo = {
            #  source = "${config.my.homeDir}/nixconf/assets/pfp2.jpg";
            #  type = "sixel";
            #  width = 24;
            #};
            display = {
              separator = "  ";
              color.keys = "blue";
              key.type = "icon";
              size = {
                ndigits = 0;
              };
            };
            modules = [
              "break"
              {
                type = "title";
                color = {
                  user = "green";
                  at = "red";
                  host = "blue";
                };
              }
              "os"
              "host"
              "kernel"
              "packages"
              {
                type = "terminalfont";
              }
              {
                type = "media";
                key = "Song";
              }
              "break"
              {
                type = "cpu";
                showPeCoresAsECores = true;
              }
              {
                type = "gpu";
                detectionMethod = "pci";
              }
              "memory"
              {
                type = "disk";
              }
              {
                type = "display";
                compactType = "original-with-refresh-rate";
              }
              {
                type = "localip";
                showIpv4 = true;
                showIpv6 = false;
                showLoop = false;
              }
              "uptime"
              "break"
              "colors"
            ];
          };
        };
        fish = {
          enable = true;
          interactiveShellInit = ''
            fish_config theme choose catppuccin-mocha --color-theme=dark
            set fish_greeting
            function fish_user_key_bindings
              fish_vi_key_bindings
            end
            function fish_mode_prompt
            end
            function y
            	set tmp (mktemp -t "yazi-cwd.XXXXXX")
            	yazi $argv --cwd-file="$tmp"
            	if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            		builtin cd -- "$cwd"
            	end
            	rm -f -- "$tmp"
            end
          '';
          functions = {
            fish_prompt = {
              body = ''
                set -l mocha_blue   \e\[38\;2\;137\;180\;250m
                set -l mocha_green  \e\[38\;2\;166\;227\;161m
                set -l mocha_red    \e\[38\;2\;243\;139\;168m
                set -l reset        \e\[0m

                set -l cwd (prompt_pwd --full-length-dirs 1 --dir-length 1)

                set -l status_color $mocha_green
                if test $status -ne 0
                  set status_color $mocha_red
                end

                if set -q SSH_CONNECTION
                  echo -s $mocha_blue (hostname) " " $reset $cwd " " $status_color ">" $reset " "
                else
                  echo -s $mocha_blue $cwd " " $status_color ">" $reset " "
                end
              '';
            };
          };
          shellAbbrs = {
            "vim" = "nvim";
            "vi" = "nvim";
            "v" = "nvim";
            "neovim" = "nvim";
            "n" = "nvim";
            "vfzf" = "nvim $(fzf)";
            "cp" = "cp -iv";
            "mv" = "mv -iv";
            "rm" = "rm -vI";
            "rsync" = "rsync -vrPlu";
            "md" = "mkdir -pv";
            "fa" = "fastfetch --config examples/13.jsonc";

            "g" = "git";
            "gc" = "git clone";
            "ga" = "git add";
            "gaa" = "git add -A";
            "gcm" = "git commit -m";
            "gp" = "git push";
            "gpp" = "git pull";

            "yt" = "yt-dlp --embed-metadata -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'";
            "yta" = "yt -x -f bestaudio/best";
            "ffmpeg" = "ffmpeg -hide_banner";

            "ls" = "eza --group-directories-first --icons always";
            "ll" = "eza --group-directories-first -lag --icons always --header";
            "grep" = "rg";
            "cat" = "bat";
            "cd" = "z";
            "cc" = "clear; z";
            "ka" = "killall";

            ".." = "z ..";
            "..." = "z ../..";
            "...." = "z ../../..";

            "untar" = "tar -zxvf";
            "mktar" = "tar -cvzf";

            # Nixos related
            "nr" = "nixos-rebuild";
            "nuc" = "nh os switch ~/nixconf -u && nh clean all";
            "nru" = "z ~/nixconf && sudo nixos-rebuild switch --flake . --upgrade";
            "nsp" = "nix-shell -p";
            "scg" = "sudo nix-collect-garbage -d";
            "ucg" = "nix-collect-garbage -d";
            "cfg" = "z ~/nixconf/";
            "rn" = "nh os switch ~/nixconf";
          };
        };
      };
    };
}
