{ ... }:

{
  imports = [ ./user.nix ];

  # shell
  programs.zsh.shellAliases = {
    nrs = "nh os switch ~/nixos-config#laptop";
    nrb = "nh os boot ~/nixos-config#laptop";
    nrt = "nh os test ~/nixos-config#laptop";
  };

  # niri
  programs.niri.settings.outputs."eDP-1" = {
    mode = {
      width = 2560;
      height = 1600;
    };
    scale = 1.25;
    variable-refresh-rate = "on-demand";
  };

  # bar
  programs.waybar.settings.mainBar = {
    modules-right = [ "tray" "niri/language" "temperature" "pulseaudio" "backlight" "battery" "power-profiles-daemon" ];
    temperature.thermal-zone = 8;

    backlight = {
      scroll-step = 0;
      format = " {percent}%";
      tooltip = false;
    };

    battery = {
      states = {
        warning = 20;
        critical = 10;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-plugged = " {capacity}%";
      format-icons = [ "" "" "" "" "" ];
      tooltip-format = "{timeTo}\n{power} W";
    };
  };
}
