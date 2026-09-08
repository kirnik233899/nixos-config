{ config, ... }: {
  imports = [
    ../../nixos/system.nix
    ./hardware.nix
  ];

  # hardware
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables.__EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";

  # power
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;
  services.logind.settings.Login.HandleLidSwitch = "suspend";

  # networking
  networking.hostName = "nixos";

  # state
  system.stateVersion = "26.05";
}
