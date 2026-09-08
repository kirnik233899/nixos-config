{ ... }:

{
  imports = [ ./user.nix ];

  # shell
  programs.zsh.shellAliases = {
    nrs = "nh os switch ~/nixos-config#pc";
    nrb = "nh os boot ~/nixos-config#pc";
    nrt = "nh os test ~/nixos-config#pc";
  };

  # niri
  programs.niri.settings.outputs."DP-2" = {
    mode = {
      width = 2560;
      height = 1440;
    };
    variable-refresh-rate = "on-demand";
  };

  # bar
  programs.waybar.settings.mainBar = {
    modules-right = [
      "tray"
      "niri/language"
      "temperature"
      "pulseaudio"
    ];
    temperature.thermal-zone = 1;
  };
}
