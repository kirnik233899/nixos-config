{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh.shellAliases = {
    nrs = "nh os switch ~/nixos-config#pc";
    nrb = "nh os boot ~/nixos-config#pc";
    nrt = "nh os test ~/nixos-config#pc";
  };

  programs.niri.settings.outputs."DP-2" = {
    mode = {
      width = 2560;
      height = 1440;
      refresh = 239.972;
    };
    variable-refresh-rate = "on-demand";
  };

  programs.waybar.settings.mainBar = {
    layer = "top";
    position = "top";
    height = 34;
    spacing = 10;

    modules-left = [ "niri/workspaces" ];
    modules-center = [ "clock" ];
    modules-right = [ "tray" "temperature" "pulseaudio" "network#wifi" "network#ethernet" ];

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
      interface = "wlo1";
      format-wifi = " {essid}";
      format-disconnected = "";
      on-click = "nm-connection-editor";
      tooltip-format-wifi = "{essid}\n{ipaddr}\nSignal: {signalStrength}%";
      tooltip-format-disconnected = "WiFi off";
    };

    "network#ethernet" = {
      interface = "enp4s0";
      format-ethernet = "";
      format-disconnected = "";
      on-click = "nm-connection-editor";
      tooltip-format-ethernet = "{ifname}\n{ipaddr}";
      tooltip-format-disconnected = "Ethernet off";
    };
  };
}
