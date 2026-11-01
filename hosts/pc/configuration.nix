{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../nixos/system.nix
    ./hardware.nix
  ];

  # hardware
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.i2c.enable = true;
  users.users.kirnik233899.extraGroups = [ "i2c" ];
  environment.systemPackages = [ pkgs.ddcutil ];

  # networking
  networking.hostName = "nixos";
  networking.networkmanager.dns = lib.mkForce "none";
  networking.networkmanager.settings.main.systemd-resolved = false;

  # state
  system.stateVersion = "26.05";
}
