{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh.shellAliases = {
    nrs = "nh os switch ~/nixos-config#laptop";
    nrb = "nh os boot ~/nixos-config#laptop";
    nrt = "nh os test ~/nixos-config#laptop";

    vpn = "doas systemctl start sing-box";
    vpnoff = "doas systemctl stop sing-box";
    vpns = "systemctl status sing-box";
    vpnlog = "journalctl -u sing-box -f";
  };

  programs.niri.settings.outputs."eDP-1" = {
    mode = {
      width = 2560;
      height = 1600;
    };
    scale = 1.25;
    variable-refresh-rate = "on-demand";
  };

  programs.niri.settings.input.touchpad = {
    tap = true;
    natural-scroll = true;
    dwt = false;
  };

  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    height = 34;
    spacing = 10;

    modules-left = [ "niri/workspaces" ];
    modules-center = [ "clock" ];
    modules-right = [ "tray" "temperature" "backlight" "battery" "pulseaudio" "network#wifi" "network#ethernet" ];

    "niri/workspaces" = {
      format = "{index}";
      all-outputs = false;
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
      spacing = 10;
      show-passive-items = true;
      reverse-direction = true;
    };

    temperature = {
      interval = 1;
      thermal-zone = 1;
      critical-threshold = 80;
      format = " {temperatureC}°C";
      tooltip = false;
    };

    backlight = {
      scroll-step = 0;
      format = "{icon} {percent}%";
      format-icons = [ "" "" "" "" "" "" "" "" "" ];
      tooltip = false;
    };

    battery = {
      interval = 1;
      states = {
        warning = 20;
        critical = 10;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-plugged = " {capacity}%";
      format-icons = [ "" "" "" "" "" ];
      tooltip-format = "{timeTo}\n{power} W";
    };

    pulseaudio = {
      scroll-step = 0;
      format = "{icon} {volume}%";
      format-muted = " {volume}%";
      format-icons = {
        default = [ "" "" "" ];
        headphone = "";
        headset = "";
      };
      on-click = "pavucontrol";
      on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      tooltip = true;
      tooltip-format = "{desc}";
    };

    "network#wifi" = {
      interface = "wlp130s0f0";
      format-wifi = " {essid}";
      format-disconnected = "";
      on-click = "nm-connection-editor";
      tooltip-format-wifi = "{essid}\n{ipaddr}\nSignal: {signalStrength}%";
      tooltip-format-disconnected = "WiFi off";
    };
"network#ethernet" = {
      interface = "enp129s0";
      format-ethernet = "";
      format-disconnected = "";
      on-click = "nm-connection-editor";
      tooltip-format-ethernet = "{ifname}\n{ipaddr}";
      tooltip-format-disconnected = "Ethernet off";
    };
  };

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/nvim";
}
