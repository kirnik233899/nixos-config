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

  # boot
  boot.loader.systemd-boot.configurationLimit = lib.mkForce 1;

  # networking
  networking.hostName = "nixos";

  # state
  system.stateVersion = "26.05";
}
