{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
    inputs.catppuccin.homeModules.catppuccin
  ];

  home.username = "kirnik233899";
  home.homeDirectory = "/home/kirnik233899";
  home.stateVersion = "25.11";

  # Catppuccin Mocha (mauve) — colors all supported programs globally
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  # Qt (follows catppuccin via kvantum)
  qt = {
    enable = true;
    style.name = "kvantum";
  };

  # Cursor
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
    size = 24;
    gtk.enable = true;
  };

  # Default apps
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "nvim.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  # nvim launches in a terminal when opened from a file manager
  xdg.desktopEntries.nvim = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "kitty -e nvim %F";
    terminal = false;
    mimeType = [ "text/plain" ];
    icon = "nvim";
  };

  # zsh + oh-my-zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      share = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git" "sudo" "fzf" "z"
        "command-not-found" "colored-man-pages" "extract"
      ];
      theme = "";
    };

    shellAliases = {
      ls   = "eza --icons --group-directories-first";
      ll   = "eza -l --icons --group-directories-first --git";
      la   = "eza -la --icons --group-directories-first --git";
      lt   = "eza --tree --icons --group-directories-first";
      cat  = "bat --paging=never";
      less = "bat";
      du   = "dust";
      df   = "duf";
      find = "fd";
      grep = "rg";
      top  = "btop";

      nrs = "doas nixos-rebuild switch --flake ~/nixos-config#pc";
      nrb = "doas nixos-rebuild boot --flake ~/nixos-config#pc";
      nrt = "doas nixos-rebuild test --flake ~/nixos-config#pc";
      ngc = "doas nix-collect-garbage -d";
      nfu = "nix flake update --flake ~/nixos-config";

      vim = "nvim";
      vi  = "nvim";

      gs  = "git status";
      ga  = "git add";
      gc  = "git commit";
      gp  = "git push";
      gl  = "git pull";
      lg  = "lazygit";

      pwr-off  = "doas systemctl poweroff";
      pwr-rb   = "doas systemctl reboot";
      pwr-susp = "doas systemctl suspend";

      mc = "mullvad connect";
      md = "mullvad disconnect";
      ms = "mullvad status";
    };

    initContent = ''
      eval "$(zoxide init zsh)"
    '';
  };

  # starship prompt
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      directory.truncation_length = 4;
      git_branch.symbol = " ";
      cmd_duration.min_time = 500;
    };
  };

  # fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # kitty
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width = 10;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      background_opacity = "0.95";
      dynamic_background_opacity = "yes";
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      scrollback_lines = 20000;
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      sync_to_monitor = "yes";
      enable_audio_bell = "no";
      shell = "${pkgs.zsh}/bin/zsh";
      detect_urls = "yes";
      url_style = "curly";
    };
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+l" = "next_tab";
      "ctrl+shift+h" = "previous_tab";
      "ctrl+shift+enter" = "new_window";
    };
  };

  # fastfetch
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = { top = 1; left = 2; };
      };
      display.separator = "  ";
      modules = [
        "title"
        "separator"
        "os"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "break"
        "colors"
      ];
    };
  };

  # git + lazygit
  programs.git = {
    enable = true;
    userName  = "kirnik233899";
    userEmail = "268614269+kirnik233899@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      color.ui = "auto";
      credential.helper = "store";
    };
  };

  programs.lazygit = {
    enable = true;
    settings.gui.showIcons = true;
  };

  # yazi
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings.manager = {
      ratio = [ 1 3 4 ];
      sort_by = "natural";
      sort_dir_first = true;
      show_hidden = false;
      show_symlink = true;
    };
  };

  # niri
  programs.niri.settings = {
    input = {
      keyboard.xkb = {
        layout = "us,ru";
        options = "grp:win_space_toggle,caps:escape";
      };
      keyboard.repeat-delay = 250;
      keyboard.repeat-rate = 35;
      touchpad = {
        tap = true;
        natural-scroll = true;
        dwt = true;
      };
      mouse.accel-speed = 0.0;
      mouse.accel-profile = "flat";
      focus-follows-mouse.enable = false;
      warp-mouse-to-focus = true;
    };

    cursor = {
      theme = "catppuccin-mocha-dark-cursors";
      size = 24;
    };

    layout = {
      gaps = 8;
      center-focused-column = "never";
      preset-column-widths = [
        { proportion = 1.0 / 3.0; }
        { proportion = 1.0 / 2.0; }
        { proportion = 2.0 / 3.0; }
      ];
      default-column-width = { proportion = 1.0 / 2.0; };
      focus-ring = {
        enable = true;
        width = 2;
        active.color = "#cba6f7";
        inactive.color = "#45475a";
      };
      border.enable = false;
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = { x = 0; y = 5; };
        color = "#000000aa";
      };
    };

    window-rules = [
      {
        matches = [{ app-id = "^firefox$"; }];
        default-column-width = { proportion = 2.0 / 3.0; };
      }
      {
        matches = [{ app-id = "^org\\.telegram\\.desktop$"; }];
        default-column-width = { proportion = 1.0 / 3.0; };
      }
    ];

    spawn-at-startup = [
      { command = [ "waybar" ]; }
      { command = [ "swaync" ]; }
      { command = [ "swww-daemon" ]; }
      { command = [ "wl-paste" "--watch" "cliphist" "store" ]; }
      { command = [ "nm-applet" "--indicator" ]; }
      { command = [ "blueman-applet" ]; }
      { command = [ "hypridle" ]; }
    ];

    binds = with config.lib.niri.actions; {
      "Mod+Return".action       = spawn "kitty";
      "Mod+D".action            = spawn "fuzzel";
      "Mod+E".action            = spawn "kitty" "-e" "yazi";
      "Mod+B".action            = spawn "firefox";
      "Mod+L".action            = spawn "hyprlock";
      "Mod+Shift+E".action      = spawn "wlogout";
      "Mod+V".action            = spawn "sh" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy";
      "Mod+Period".action       = spawn "bemoji";

      "Print".action            = spawn "sh" "-c" "grim -g \"$(slurp)\" - | satty --filename - --output-filename ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";
      "Shift+Print".action      = spawn "sh" "-c" "grim ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png";

      "Mod+Q".action            = close-window;
      "Mod+H".action            = focus-column-left;
      "Mod+L".action            = focus-column-right;
      "Mod+J".action            = focus-window-down;
      "Mod+K".action            = focus-window-up;
      "Mod+Shift+H".action      = move-column-left;
      "Mod+Shift+L".action      = move-column-right;
      "Mod+R".action            = switch-preset-column-width;
      "Mod+F".action            = maximize-column;
      "Mod+Shift+F".action      = fullscreen-window;
      "Mod+W".action            = expand-column-to-available-width;

      "Mod+1".action = focus-workspace 1;
      "Mod+2".action = focus-workspace 2;
      "Mod+3".action = focus-workspace 3;
      "Mod+4".action = focus-workspace 4;
      "Mod+5".action = focus-workspace 5;
      "Mod+Shift+1".action = move-window-to-workspace 1;
      "Mod+Shift+2".action = move-window-to-workspace 2;
      "Mod+Shift+3".action = move-window-to-workspace 3;
      "Mod+Shift+4".action = move-window-to-workspace 4;
      "Mod+Shift+5".action = move-window-to-workspace 5;

      "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "-l" "1.5" "@DEFAULT_AUDIO_SINK@" "5%+";
      "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
      "XF86AudioMute".action        = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
      "XF86AudioPlay".action        = spawn "playerctl" "play-pause";
      "XF86AudioNext".action        = spawn "playerctl" "next";
      "XF86AudioPrev".action        = spawn "playerctl" "previous";

      "Mod+Shift+Q".action = quit;
    };

    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
  };

  # waybar
  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 6;
      modules-left = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "tray" "cpu" "memory" "temperature" "pulseaudio" "network" "bluetooth" ];

      "niri/workspaces".format = "{icon}";
      "niri/workspaces".format-icons = { default = "○"; active = "●"; };
      "niri/window".max-length = 60;

      clock.format = "  {:%H:%M  %a %d %b}";
      cpu.format = "  {usage}%";
      memory.format = "  {percentage}%";
      temperature = {
        format = "  {temperatureC}°C";
        critical-threshold = 80;
      };
      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "  muted";
        format-icons.default = [ "" "" "" ];
        on-click = "pavucontrol";
      };
      network = {
        format-wifi = "  {essid}";
        format-ethernet = "  {ipaddr}";
        format-disconnected = "  off";
        on-click = "nm-connection-editor";
      };
      bluetooth = {
        format = "  {status}";
        on-click = "blueman-manager";
      };
      tray.spacing = 8;
    };

    style = ''
      * { font-family: "JetBrainsMono Nerd Font", "Inter"; font-size: 13px; }
      #workspaces button { padding: 0 6px; }
      #window { padding: 0 8px; }
      #clock, #cpu, #memory, #temperature,
      #pulseaudio, #network, #bluetooth, #tray { padding: 0 10px; }
    '';
  };

  # fuzzel
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=12";
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        width = 50;
        lines = 12;
        prompt = "  ";
        icon-theme = "Papirus-Dark";
      };
      border = { radius = 10; width = 2; };
    };
  };

  # swaync
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      control-center-margin-top = 10;
      control-center-margin-right = 10;
      notification-window-width = 380;
      timeout = 8;
      timeout-low = 4;
      timeout-critical = 0;
    };
  };

  # hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
        grace = 0;
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
        outline_thickness = 2;
        fade_on_empty = false;
        placeholder_text = "<i>password</i>";
        hide_input = false;
      }];
      label = [
        {
          text = "$TIME";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:60000] echo \"$(date '+%A, %d %B')\"";
          font_size = 20;
          font_family = "Inter";
          position = "0, 130";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };
      listener = [
        {
          timeout = 300;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";
        }
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
      ];
    };
  };

  # User packages
  home.packages = with pkgs; [
    playerctl
  ];
}
