{
  config,
  lib,
  pkgs,
  ...
}:

{
  # home
  home.username = "kirnik233899";
  home.homeDirectory = "/home/kirnik233899";
  home.stateVersion = "26.05";

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # theme
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "violet"; };
    };
  };
  qt.enable = true;

  # xdg
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.file."Pictures/Screenshots/.keep".text = "";

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "kitty -e nvim %F";
    icon = "nvim";
    mimeType = [
      "text/plain"
      "text/markdown"
      "application/json"
      "text/x-shellscript"
    ];
    terminal = false;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "image/gif" = "imv.desktop";
      "image/webp" = "imv.desktop";
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "text/x-shellscript" = "nvim.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  # shell
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "history"
        "completion"
      ];
    };
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      extended = true;
      ignoreAllDups = true;
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first --git";
      la = "eza -la --icons --group-directories-first --git";
      lt = "eza --tree --icons --group-directories-first";
      cat = "bat --paging=never";
      du = "dust";
      df = "duf";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      nca = "nh clean all";
      nfu = "nix flake update --flake ~/nixos-config";

      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      lg = "lazygit";

      off = "doas systemctl poweroff";
      rb = "doas systemctl reboot";
      susp = "doas systemctl suspend";
    };

    initContent = ''
      setopt AUTO_CD
      setopt INTERACTIVE_COMMENTS
      setopt HIST_REDUCE_BLANKS
      setopt NO_BEEP

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
      zstyle ':completion:*' rehash true

      export LESS_TERMCAP_mb=$'\e[1;31m'
      export LESS_TERMCAP_md=$'\e[1;36m'
      export LESS_TERMCAP_me=$'\e[0m'
      export LESS_TERMCAP_se=$'\e[0m'
      export LESS_TERMCAP_so=$'\e[1;44;33m'
      export LESS_TERMCAP_ue=$'\e[0m'
      export LESS_TERMCAP_us=$'\e[1;32m'

      if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
        fastfetch
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git_branch.symbol = " ";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--reverse"
      "--border"
      "--info=inline"
    ];
    fileWidget.options = [
      "--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza --tree --color=always {} 2>/dev/null'"
    ];
    changeDirWidget.options = [ "--preview 'eza --tree --color=always --level=2 {} 2>/dev/null'" ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # terminal
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      cursor_blink_interval = "0.5";
      cursor_shape = "beam";
      enable_audio_bell = "no";
      hide_window_decorations = "yes";
      scrollback_lines = 25000;
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      window_padding_width = 10;
    };
    keybindings = {
      "ctrl+shift+x" = "close_tab";
      "ctrl+shift+j" = "previous_tab";
      "ctrl+shift+k" = "next_tab";
    };
  };

  # fetch
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "builtin";
        source = "GrapheneOS";
        color = {
          "1" = "blue";
          "2" = "blue";
        };
      };
      display.separator = " => ";
      modules = [
        {
          type = "title";
          color = {
            user = "magenta";
            at = "magenta";
            host = "magenta";
          };
        }
        {
          type = "separator";
          outputColor = "magenta";
        }
        "break"
        {
          type = "host";
          keyColor = "blue";
        }
        {
          type = "disk";
          keyColor = "blue";
        }
        {
          type = "swap";
          keyColor = "blue";
        }
        {
          type = "memory";
          keyColor = "blue";
        }
        {
          type = "cpu";
          keyColor = "blue";
        }
        {
          type = "gpu";
          keyColor = "blue";
        }
        {
          type = "display";
          keyColor = "blue";
        }
        "break"
        {
          type = "bios";
          keyColor = "green";
        }
        {
          type = "bootmgr";
          keyColor = "green";
        }
        {
          type = "kernel";
          keyColor = "green";
        }
        {
          type = "initsystem";
          keyColor = "green";
        }
        {
          type = "os";
          keyColor = "green";
        }
        {
          type = "packages";
          keyColor = "green";
        }
        "break"
        {
          type = "localip";
          keyColor = "yellow";
        }
        {
          type = "wifi";
          keyColor = "yellow";
        }
        {
          type = "dns";
          keyColor = "yellow";
        }
        "break"
        {
          type = "wm";
          keyColor = "red";
        }
        {
          type = "shell";
          keyColor = "red";
        }
        {
          type = "terminal";
          keyColor = "red";
        }
        {
          type = "terminalfont";
          keyColor = "red";
        }
        {
          type = "font";
          keyColor = "red";
        }
        {
          type = "theme";
          keyColor = "red";
        }
        {
          type = "icons";
          keyColor = "red";
        }
        {
          type = "cursor";
          keyColor = "red";
        }
        "break"
        {
          type = "locale";
          keyColor = "cyan";
        }
        {
          type = "uptime";
          keyColor = "cyan";
        }
        {
          type = "battery";
          keyColor = "cyan";
        }
        {
          type = "datetime";
          keyColor = "cyan";
        }
        "break"
        "colors"
      ];
    };
  };

  # btop
  stylix.targets.btop.enable = false;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "TTY";
      theme_background = false;
      vim_keys = true;
    };
  };

  # git
  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
    settings = {
      user.name = "kirnik233899";
      user.email = "268614269+kirnik233899@users.noreply.github.com";
      core.editor = "nvim";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      gpg.ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      navigate = true;
      side-by-side = true;
    };
  };

  home.file.".ssh/allowed_signers".text = ''
    268614269+kirnik233899@users.noreply.github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG++riFCEvXU74XfGycSVh9k6PhNQD/1T6dxSNmKsxgD laptop
  '';

  programs.lazygit = {
    enable = true;
    settings = {
      gui.nerdFontsVersion = "3";
    };
  };

  # files
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings.mgr = {
      sort_by = "natural";
    };
  };

  # editor
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";

  # niri
  programs.niri.settings = {
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;

    workspaces = {
      "01".name = "1";
      "02".name = "2";
      "03".name = "3";
      "04".name = "4";
      "05".name = "5";
      "06".name = "6";
      "07".name = "7";
      "08".name = "8";
      "09".name = "9";
    };

    environment = {
      NIXOS_OZONE_WL = "1";
    };

    input = {
      keyboard.xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle";
      };
      focus-follows-mouse.enable = true;
      mouse.accel-profile = "flat";
    };

    gestures = {
      hot-corners.enable = false;
    };

    layout = {
      border = {
        width = 2;
        active.color = config.lib.stylix.colors.withHashtag.base0E;
      };
    };

    window-rules = [
      {
        matches = [
          { app-id = "org.pulseaudio.pavucontrol"; }
          { app-id = "blueman-manager"; }
          { app-id = "qalculate-gtk"; }
          { app-id = "nm-connection-editor"; }
        ];
        open-floating = true;
      }
      {
        matches = [
          { app-id = "mpv"; }
          { app-id = "gamescope"; }
        ];
        variable-refresh-rate = true;
      }
    ];

    spawn-at-startup = [
      {
        command = [
          "mpvpaper"
          "-p"
          "-a"
          "full"
          "-o"
          "no-audio loop panscan=1.0"
          "*"
          "${config.home.homeDirectory}/Videos/abstract-purple.mp4"
        ];
      }
    ];

    binds = with config.lib.niri.actions; {
      "Mod+T".action = spawn "kitty";
      "Mod+R".action = spawn "fuzzel";
      "Mod+E".action = spawn "kitty" "-e" "yazi";
      "Mod+V".action = spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
      "Mod+N".action = spawn "swaync-client" "-t" "-sw";
      "Mod+Escape".action = spawn "hyprlock";

      "Mod+Q".action = close-window;
      "Mod+G".action = toggle-window-floating;
      "Mod+F".action = maximize-window-to-edges;
      "Mod+Shift+F".action = fullscreen-window;
      "Mod+Tab".action = toggle-overview;

      "Mod+A".action = focus-column-left;
      "Mod+D".action = focus-column-right;
      "Mod+S".action = focus-window-down;
      "Mod+W".action = focus-window-up;

      "Mod+Shift+A".action = move-column-left;
      "Mod+Shift+D".action = move-column-right;
      "Mod+Shift+S".action = move-window-down;
      "Mod+Shift+W".action = move-window-up;

      "Mod+Z".action = consume-or-expel-window-left;
      "Mod+X".action = consume-or-expel-window-right;

      "Mod+Minus".action =
        spawn "sh" "-c"
          "niri msg action move-window-to-tiling; niri msg action set-column-width \"-10%\"";
      "Mod+Equal".action =
        spawn "sh" "-c"
          "niri msg action move-window-to-tiling; niri msg action set-column-width \"+10%\"";
      "Mod+C".action =
        spawn "sh" "-c"
          "niri msg action move-window-to-tiling; niri msg action switch-preset-column-width";

      "Mod+1".action = focus-workspace "1";
      "Mod+2".action = focus-workspace "2";
      "Mod+3".action = focus-workspace "3";
      "Mod+4".action = focus-workspace "4";
      "Mod+5".action = focus-workspace "5";
      "Mod+6".action = focus-workspace "6";
      "Mod+7".action = focus-workspace "7";
      "Mod+8".action = focus-workspace "8";
      "Mod+9".action = focus-workspace "9";
      "Mod+0".action = focus-workspace 10;

      "Mod+Shift+1".action.move-column-to-workspace = [ "1" ];
      "Mod+Shift+2".action.move-column-to-workspace = [ "2" ];
      "Mod+Shift+3".action.move-column-to-workspace = [ "3" ];
      "Mod+Shift+4".action.move-column-to-workspace = [ "4" ];
      "Mod+Shift+5".action.move-column-to-workspace = [ "5" ];
      "Mod+Shift+6".action.move-column-to-workspace = [ "6" ];
      "Mod+Shift+7".action.move-column-to-workspace = [ "7" ];
      "Mod+Shift+8".action.move-column-to-workspace = [ "8" ];
      "Mod+Shift+9".action.move-column-to-workspace = [ "9" ];
      "Mod+Shift+0".action.move-column-to-workspace = [ 10 ];

      "Mod+WheelScrollDown".action = focus-column-right;
      "Mod+WheelScrollUp".action = focus-column-left;

      "Mod+F1".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "Mod+F2".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "Mod+F3".action = spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+";
      "Mod+F4".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      "Mod+F5".action = spawn "brightnessctl" "-d" "intel_backlight" "set" "5%-";
      "Mod+F6".action = spawn "brightnessctl" "-d" "intel_backlight" "set" "5%+";
      "Mod+F7".action =
        spawn "sh" "-c"
          "pkill wf-recorder || wf-recorder -a \"$(pactl get-default-sink).monitor\" -f ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4";
      "Mod+F11".action = spawn "bemoji";
      "Mod+F12".action = spawn "qalculate-gtk";

      "Print".action =
        spawn "sh" "-c"
          "grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
      "Mod+Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty --filename -";

      "Mod+Shift+Q".action = quit;
    };
  };

  # autostart
  services.cliphist.enable = true;
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.hyprpolkitagent.enable = true;
  xsession.preferStatusNotifierItems = true;

  # bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 36;
      spacing = 12;

      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];
      modules-center = [
        "clock"
        "privacy"
      ];

      "niri/window" = {
        max-length = 50;
      };

      clock = {
        interval = 1;
        locale = "en_US.UTF-8";
        format = "{:%a %d %b %H:%M:%S}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "month";
          format = {
            today = "<b>{}</b>";
          };
        };
      };

      tray = {
        spacing = 12;
        show-passive-items = true;
        reverse-direction = true;
      };

      "niri/language" = {
        format = "{short}";
      };

      temperature = {
        interval = 1;
        critical-threshold = 80;
        format = " {temperatureC}°C";
        format-critical = " {temperatureC}°C";
        tooltip = false;
      };

      pulseaudio = {
        scroll-step = 0;
        format = "<span size='150%'>{icon}</span> {volume}%";
        format-muted = "<span size='150%'>󰖁</span> {volume}%";
        format-icons = {
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
        on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        tooltip = true;
        tooltip-format = "{desc}";
      };
    };

    style = lib.mkAfter ''
      * {
        min-height: 0;
      }
      #workspaces button {
        padding: 0 8px;
        color: @base04;
        background: transparent;
      }
      #workspaces button.active {
        color: @base00;
        background: @base0E;
        border-radius: 6px;
      }
      #workspaces button.urgent {
        color: @base00;
        background: #ff5555;
        border-radius: 6px;
      }
      #clock,
      #privacy,
      #tray,
      #language,
      #temperature,
      #pulseaudio,
      #backlight,
      #battery,
      #power-profiles-daemon {
        padding: 0 10px;
      }
      #temperature.critical {
        color: #ff5555;
      }
      #pulseaudio.muted {
        color: @base03;
      }
      #battery.warning {
        color: #ffcc00;
      }
      #battery.critical {
        color: #ff5555;
      }
    '';
  };

  # launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        prompt = "=> ";
        icon-theme = "Papirus-Dark";
      };
      border = {
        width = 2;
      };
    };
  };

  # notifications
  services.swaync = {
    enable = true;
    settings = {
      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config.mpris.autohide = true;
    };
  };

  # lock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };
      background = {
        path = "screenshot";
        blur_passes = 3;
      };
      input-field = {
        fade_on_empty = false;
        outline_thickness = 2;
      };
      label = [
        {
          text = "$TIME";
          font_size = 64;
          position = "0, 150";
        }
        {
          text = "$USER";
          position = "0, 80";
        }
        {
          text = "$LAYOUT[us,ru]";
          position = "0, -80";
        }
      ];
    };
  };
}
