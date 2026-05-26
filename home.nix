{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    inputs.niri.homeModules.niri
  ];

  home.username = "kirnik233899";
  userEmail = "268614269+kirnik233899@users.noreply.github.com";
  home.stateVersion = "25.11";

  ###########################################################################
  # Tokyo Night Moon look — GTK theme, icons, cursor, Qt follows GTK
  ###########################################################################
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "Inter";
      size = 11;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "org.gnome.TextEditor.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  ###########################################################################
  # zsh + oh-my-zsh + aliases
  ###########################################################################
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
      theme = ""; # starship handles the prompt
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

      # NixOS workflow
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

  ###########################################################################
  # starship prompt (Tokyo Night Moon colors)
  ###########################################################################
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold #82aaff)";
        error_symbol = "[✗](bold #ff757f)";
      };
      directory = {
        style = "bold #82aaff";
        truncation_length = 4;
      };
      git_branch = {
        symbol = " ";
        style = "bold #c099ff";
      };
      git_status.style = "bold #ff757f";
      cmd_duration = {
        min_time = 500;
        style = "bold #ffc777";
      };
    };
  };

  ###########################################################################
  # kitty terminal
  ###########################################################################
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_moon";
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

  ###########################################################################
  # git + lazygit
  ###########################################################################
  programs.git = {
    enable = true;
    # CHANGE ME if you want different name/email in commits.
    userName  = "kirnik233899";
    userEmail = "kirnik233899@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        syntax-theme = "tokyonight_moon";
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
    settings = {
      gui.theme = {
        activeBorderColor = [ "#c099ff" "bold" ];
        inactiveBorderColor = [ "#3b4261" ];
        selectedLineBgColor = [ "#283457" ];
      };
      gui.showIcons = true;
      git.paging = {
        colorArg = "always";
        pager = "delta --paging=never";
      };
    };
  };

  ###########################################################################
  # yazi
  ###########################################################################
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

  ###########################################################################
  # niri compositor settings + keybinds
  ###########################################################################
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
      theme = "Bibata-Modern-Classic";
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
        active.color = "#c099ff";
        inactive.color = "#3b4261";
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
      "Mod+E".action            = spawn "thunar";
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

  ###########################################################################
  # waybar
  ###########################################################################
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
      window#waybar {
        background: rgba(31, 35, 53, 0.92);
        color: #c8d3f5;
        border-bottom: 1px solid #3b4261;
      }
      #workspaces button { padding: 0 6px; color: #828bb8; }
      #workspaces button.focused { color: #c099ff; }
      #window { color: #82aaff; padding: 0 8px; }
      #clock, #cpu, #memory, #temperature,
      #pulseaudio, #network, #bluetooth, #tray { padding: 0 10px; }
      #cpu        { color: #c3e88d; }
      #memory     { color: #ffc777; }
      #temperature{ color: #ff966c; }
      #pulseaudio { color: #82aaff; }
      #network    { color: #86e1fc; }
      #bluetooth  { color: #c099ff; }
      #clock      { color: #fcdfff; }
    '';
  };

  ###########################################################################
  # fuzzel launcher
  ###########################################################################
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
      colors = {
        background = "1f2335f0";
        text       = "c8d3f5ff";
        match      = "c099ffff";
        selection  = "3b4261ff";
        selection-text = "c8d3f5ff";
        border     = "c099ffff";
      };
      border = { radius = 10; width = 2; };
    };
  };

  ###########################################################################
  # swaync notifications
  ###########################################################################
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
    style = ''
      * { font-family: "Inter", "JetBrainsMono Nerd Font"; font-size: 13px; }
      .notification-row { background: transparent; }
      .notification {
        background: #1f2335;
        color: #c8d3f5;
        border: 1px solid #c099ff;
        border-radius: 10px;
        margin: 6px;
      }
      .control-center {
        background: #1f2335;
        color: #c8d3f5;
        border: 1px solid #3b4261;
        border-radius: 12px;
      }
    '';
  };

  ###########################################################################
  # hyprlock + hypridle
  ###########################################################################
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
        outer_color = "rgb(c099ff)";
        inner_color = "rgb(1f2335)";
        font_color = "rgb(c8d3f5)";
        fade_on_empty = false;
        placeholder_text = "<i>password</i>";
        hide_input = false;
      }];
      label = [
        {
          text = "$TIME";
          color = "rgb(c8d3f5)";
          font_size = 64;
          font_family = "JetBrainsMono Nerd Font Bold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:60000] echo \"$(date '+%A, %d %B')\"";
          color = "rgb(82aaff)";
          font_size = 20;
          font_family = "Inter";
          position = "0, 130";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

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

  ###########################################################################
  # User-level packages: theme assets + small CLI helpers used by hotkeys
  ###########################################################################
  home.packages = with pkgs; [
    tokyonight-gtk-theme
    papirus-icon-theme
    playerctl
  ];
}
