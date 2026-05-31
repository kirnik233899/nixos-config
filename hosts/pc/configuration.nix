{ config, pkgs, lib, inputs, ... }:
{
  # nixos-generate-config
  imports = [
    ./hardware-configuration.nix
  ];

  # systemd-boot (UEFI)
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
      consoleMode = "max";
    };
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
  ];

  # CPU microcode
  hardware.cpu.intel.updateMicrocode = true;

  # btrfs
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };
  services.fstrim.enable = true;

  # Snapper snapshots
  services.snapper.configs.home = {
    SUBVOLUME = "/home";
    ALLOW_USERS = [ "kirnik233899" ];
    TIMELINE_CREATE = true;
    TIMELINE_CLEANUP = true;
    TIMELINE_LIMIT_HOURLY = "5";
    TIMELINE_LIMIT_DAILY = "7";
    TIMELINE_LIMIT_WEEKLY = "4";
    TIMELINE_LIMIT_MONTHLY = "3";
    TIMELINE_LIMIT_YEARLY = "0";
  };

  # zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # NVIDIA RTX
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # Timezone
  services.geoclue2.enable = true;
  services.automatic-timezoned.enable = true;
  time.timeZone = null;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  console.keyMap = "us";

  # User
  users.users.kirnik233899 = {
    isNormalUser = true;
    description = "kirnik233899";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "render" "kvm" "libvirtd" ];
    shell = pkgs.zsh;
    # passwd kirnik233899
  };
  programs.zsh.enable = true;

  # doas
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [{
      users = [ "kirnik233899" ];
      keepEnv = true;
      persist = true;
    }];
  };

  # Login
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  # niri
  programs.niri.enable = true;
  services.xserver.enable = false;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config.common.default = [ "gtk" ];
  };

  # xwayland-satellite
  programs.niri.package = pkgs.niri;
  systemd.user.services.xwayland-satellite = {
    description = "Xwayland outside your Wayland";
    wantedBy = [ "niri.service" ];
    partOf = [ "niri.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
    };
  };

  # Desktop session
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  programs.dconf.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      inter
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
    ];
    fontconfig.defaultFonts = {
      serif     = [ "Noto Serif" ];
      sansSerif = [ "Inter" "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };

  # Catppuccin
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # Programs
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wl-clipboard cliphist grim slurp satty wlogout swww bemoji p7zip unrar zip unzip xarchiver mpv imv zathura firefox brave vim neovim vscodium jetbrains.pycharm-community telegram-desktop vesktop pavucontrol networkmanagerapplet udiskie gammastep mangohud lutris bottles heroic gamescope vkbasalt goverlay protontricks winetricks wineWowPackages.staging prismlauncher distrobox eza bat du-dust duf fd ripgrep fzf zoxide btop htop lm_sensors smartmontools git lazygit delta tmux curl wget aria2 rsync tree file pciutils usbutils inxi parted gptfdisk nvme-cli playerctl brightnessctl wf-recorder jq hyprpolkitagent gcc nh nix-output-monitor gimp inkscape blender libreoffice-fresh obsidian qalculate-gtk imagemagick obs-studio transmission_4-gtk spotify hiddify-app cmatrix cbonsai pipes sl asciiquarium-transparent cava
  ];

  # Containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Flatpak
  services.flatpak.enable = true;

  # vpn
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # Nix
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" "kirnik233899" ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://niri.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  system.stateVersion = "25.11";
}
