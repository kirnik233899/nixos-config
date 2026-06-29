{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
  ];

  home.username = "kirnik233899";
  home.homeDirectory = "/home/kirnik233899";
  home.stateVersion = "26.05";

  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  gtk = {
    enable = true;
    font = {
      name = "Inter";
      size = 11;
   };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };

  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    documents = "${config.home.homeDirectory}/Documents";
  };

  home.file."Pictures/Screenshots/.keep".text = "";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      extended = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [
        "git"
        "fzf"
        "command-not-found"
        "colored-man-pages"
        "extract"
      ];
    };

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first --git";
      la = "eza -la --icons --group-directories-first --git";
      lt = "eza --tree --icons --group-directories-first";
      cat = "bat --paging=never";
      du = "dust";
      df = "duf";
      find = "fd";
      grep = "rg";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      ncg = "nh clean all";
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

      export EDITOR=nvim
      export VISUAL=nvim

      export FZF_DEFAULT_OPTS="--height 40% --reverse --border --info=inline --no-mouse"
      export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || eza --tree --color=always {} 2>/dev/null'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} 2>/dev/null'"

      eval "$(zoxide init zsh)"

      if [[ -o interactive ]] && command -v fastfetch &>/dev/null; then
        fastfetch
      fi
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      cmd_duration.min_time = 500;
      directory.truncation_length = 4;
      git_branch.symbol = " ";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "kitty -e nvim %F";
    icon = "nvim";
    mimeType = [ "text/plain" ];
    terminal = false;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/jpeg" = "imv.desktop";
      "image/png" = "imv.desktop";
      "text/plain" = "nvim.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.95";
      confirm_os_window_close = 0;
      cursor_blink_interval = "0.5";
      cursor_shape = "beam";
      detect_urls = "yes";
      dynamic_background_opacity = "yes";
      enable_audio_bell = "no";
      hide_window_decorations = "yes";
      scrollback_lines = 25000;
      shell = "${pkgs.zsh}/bin/zsh";
      sync_to_monitor = "yes";
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      url_style = "curly";
      window_padding_width = 10;
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+x" = "close_tab";
      "ctrl+shift+j" = "previous_tab";
      "ctrl+shift+k" = "next_tab";
    };
  };

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
        { type = "title"; color = { user = "magenta"; at = "magenta"; host = "magenta"; }; }
        { type = "separator"; outputColor = "magenta"; }
        "break"
        { type = "host"; keyColor = "blue"; }
        { type = "cpu"; keyColor = "blue"; }
        { type = "gpu"; keyColor = "blue"; }
        { type = "memory"; keyColor = "blue"; }
        { type = "disk"; keyColor = "blue"; }
        { type = "swap"; keyColor = "blue"; }
        { type = "display"; keyColor = "blue"; }
        "break"
        { type = "bios"; keyColor = "green"; }
        { type = "bootmgr"; keyColor = "green"; }
        { type = "kernel"; keyColor = "green"; }
        { type = "initsystem"; keyColor = "green"; }
        { type = "os"; keyColor = "green"; }
        { type = "packages"; keyColor = "green"; }
        "break"
        { type = "localip"; keyColor = "yellow"; }
        { type = "wifi"; keyColor = "yellow"; }
        { type = "dns"; keyColor = "yellow"; }
        "break"
        { type = "wm"; keyColor = "red"; }
        { type = "shell"; keyColor = "red"; }
        { type = "terminal"; keyColor = "red"; }
        { type = "terminalfont"; keyColor = "red"; }
        { type = "font"; keyColor = "red"; }
        { type = "theme"; keyColor = "red"; }
        { type = "icons"; keyColor = "red"; }
        { type = "cursor"; keyColor = "red"; }
        "break"
        { type = "locale"; keyColor = "cyan"; }
        { type = "uptime"; keyColor = "cyan"; }
        { type = "battery"; keyColor = "cyan"; }
        { type = "datetime"; keyColor = "cyan"; }
        "break"
        "colors"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "kirnik233899";
    userEmail = "268614269+kirnik233899@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
        side-by-side = true;
      };
    };
    extraConfig = {
      color.ui = "auto";
      core.editor = "nvim";
      credential.helper = "store";
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui.showIcons = true;
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings.manager = {
      ratio = [ 1 4 3 ];
      show_hidden = false;
      show_symlink = true;
      sort_by = "natural";
      sort_dir_first = true;
    };
  };

  programs.niri.settings = {
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;

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
      warp-mouse-to-focus = true;
    };

    layout = {
      gaps = 16;
      border = {
        enable = true;
        width = 2;
        active.color = "#cba6f7";
        inactive.color = "#45475a";
      };
      focus-ring.enable = false;
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
          { app-id = "^mpv$"; }
          { app-id = "^gamescope$"; }
        ];
        variable-refresh-rate = true;
      }
    ];

    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [ "swaync" ]; }
      { command = [ "awww-daemon" ]; }
      { command = [ "wl-paste" "--type" "text" "--watch" "cliphist" "store" ]; }
      { command = [ "wl-paste" "--type" "image" "--watch" "cliphist" "store" ]; }
      { command = [ "nm-applet" "--indicator" ]; }
      { command = [ "blueman-applet" ]; }
      { command = [ "systemctl" "--user" "start" "hyprpolkitagent" ]; }
      { command = [ "sh" "-c" "awww-daemon & sleep 1 && awww img ~/Pictures/wallpapers/minimalist-black-hole.png" ]; }
    ];

    binds = with config.lib.niri.actions; {
      "Mod+T".action = spawn "kitty";
      "Mod+R".action = spawn "fuzzel";
      "Mod+E".action = spawn "kitty" "-e" "yazi";
      "Mod+Q".action = close-window;
      "Mod+N".action = spawn "swaync-client" "-t" "-sw";
      "Mod+Escape".action = spawn "hyprlock";

      "Mod+A".action = focus-column-left;
      "Mod+D".action = focus-column-right;
      "Mod+S".action = focus-window-down;
      "Mod+W".action = focus-window-up;

      "Mod+Shift+A".action = move-column-left;
      "Mod+Shift+D".action = move-column-right;
      "Mod+Shift+S".action = move-window-down;
      "Mod+Shift+W".action = move-window-up;

      "Mod+Minus".action = set-column-width "-10%";
      "Mod+Equal".action = set-column-width "+10%";
      "Mod+C".action = switch-preset-column-width;

      "Mod+F".action = maximize-column;
      "Mod+Shift+F".action = fullscreen-window;

      "Mod+1".action = focus-workspace-up;
      "Mod+2".action = focus-workspace-down;
      "Mod+Shift+1".action = move-column-to-workspace-up;
      "Mod+Shift+2".action = move-column-to-workspace-down;

      "Mod+WheelScrollDown".action = focus-column-right;
      "Mod+WheelScrollUp".action = focus-column-left;

      "Mod+V".action = spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
      "Mod+Shift+Space".action = toggle-window-floating;

      "Mod+F1".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "Mod+F2".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "Mod+F3".action = spawn "wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+";
      "Mod+F4".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
      "Mod+F5".action = spawn "brightnessctl" "set" "5%-";
      "Mod+F6".action = spawn "brightnessctl" "set" "5%+";
      "Mod+F7".action = spawn "sh" "-c" "pkill wf-recorder || wf-recorder -a \"$(pactl get-default-sink).monitor\" -f ~/Videos/$(date +%Y-%m-%d_%H-%M-%S).mp4";

      "Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png | wl-copy";
      "Mod+Print".action = spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty --filename -";

      "Mod+Shift+E".action = quit;
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    style = ''
    * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
        min-height: 0;
      }
      window#waybar {
        background: @base;
        color: @text;
      }
      #workspaces button {
        padding: 0 8px;
        color: @subtext0;
        background: transparent;
      }
      #workspaces button.active {
        color: @base;
        background: @mauve;
        border-radius: 6px;
      }
      #workspaces button.urgent {
        color: @base;
        background: @red;
        border-radius: 6px;
      }
      #clock,
      #temperature,
      #pulseaudio,
      #network,
      #tray {
        padding: 0 10px;
        color: @text;
      }
      #temperature.critical {
        color: @red;
      }
      #pulseaudio.muted {
        color: @overlay0;
      }
      #network.disconnected {
        color: @red;
      }
    '';
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 30;
        lines = 15;
        prompt = "=> ";
        icon-theme = "Papirus-Dark";
      };
      border = {
        radius = 10;
        width = 2;
      };
    };
  };

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-right = 10;
      control-center-margin-bottom = 10;
      control-center-margin-left = 10;
      timeout = 5;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      widgets = [
        "title"
        "dnd"
        "notifications"
        "mpris"
      ];
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          image-size = 96;
          image-radius = 8;
        };
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }];
      input-field = [{
        size = "300, 50";
        position = "0, -80";
        halign = "center";
        valign = "center";
        fade_on_empty = false;
        hide_input = true;
        outline_thickness = 2;
        placeholder_text = "<i>password</i>";
      }];
      label = [
        {
          text = "cmd[update:1000] echo \"$(date '+%a %d %b %H:%M:%S')\"";
          font_family = "JetBrainsMono Nerd Font Bold";
          font_size = 32;
          position = "0, -120";
          halign = "center";
          valign = "top";
        }
        {
          text = "$USER";
          font_family = "Inter";
          font_size = 18;
          position = "0, -10";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo \"$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)%\"";
          font_family = "JetBrainsMono Nerd Font";
          font_size = 16;
          position = "30, -30";
          halign = "left";
          valign = "top";
        }
        {
          text = "cmd[update:1000] echo \"$(niri msg --json keyboard-layouts | jq -r '.names[.current_idx]' 2>/dev/null)\"";
          font_family = "Inter";
          font_size = 16;
          position = "-30, -30";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
