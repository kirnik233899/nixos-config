{ pkgs, ... }: {
  imports = [
    ../../nixos/system.nix
    ./hardware.nix
  ];

  # hardware
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables.__EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";

  services.udev.packages = [ pkgs.brightnessctl ];
  environment.systemPackages = [ pkgs.brightnessctl ];

  # audio
  hardware.firmware = [
    (pkgs.runCommand "aw88399-firmware" {
      src = pkgs.fetchurl {
        url = "https://gitlab.com/kernel-firmware/linux-firmware/-/raw/1cafb17a3ead182e37ab572964bee2a692a554c5/awinic/aw88399_acf_17aa3906.bin";
        hash = "sha256-HpJ8m8p22GgYHA+B3yvM7zzxnH0JECGfIpNgyHur1Cw=";
      };
    } "install -Dm444 $src $out/lib/firmware/aw88399_acf.bin")
  ];

  services.pipewire.wireplumber.extraConfig."51-output-priority-laptop"."monitor.alsa.rules" = [
    {
      matches = [ { "node.name" = "alsa_output.pci-0000_80_1f.3.analog-stereo"; } ];
      actions.update-props."priority.session" = 1100;
    }
  ];

  # power
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.upower.enable = true;
  services.logind.settings.Login.HandlePowerKey = "ignore";

  # networking
  networking.hostName = "nixos";

  # state
  system.stateVersion = "26.05";
}
