{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # secrets
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets.sing-box = {
      sopsFile = ../secrets/sing-box.json;
      format = "binary";
      restartUnits = [ "sing-box.service" ];
    };
  };

  # storage
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  services.fstrim.enable = true;

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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  # hardware
  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # boot
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10;
    consoleMode = "max";
    memtest86.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 3;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.tmp.cleanOnBoot = true;

  # nix
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "root"
      "kirnik233899"
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    warn-dirty = false;
    download-buffer-size = 1073741824;
  };

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    flake = "/home/kirnik233899/nixos-config";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 10 --keep-since 30d";
    };
  };

  # networking
  networking.networkmanager.enable = true;
  networking.networkmanager.dns = "systemd-resolved";
  networking.networkmanager.settings.connection = {
    "ipv4.ignore-auto-dns" = true;
    "ipv6.ignore-auto-dns" = true;
  };

  networking.firewall.enable = true;

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [
        "194.242.2.2#dns.mullvad.net"
        "194.242.2.3#dns.mullvad.net"
      ];
      DNSOverTLS = true;
      Domains = [ "~." ];
    };
  };

  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  systemd.services.sing-box = {
    description = "sing-box proxy";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.sing-box}/bin/sing-box run -c ${config.sops.secrets.sing-box.path}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  services.i2pd.enable = true;

  # audio
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

  services.pipewire.wireplumber.extraConfig."51-output-priority" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.usb-Razer_Razer_Kraken_V3_HyperSense.*analog-stereo"; } ];
        actions.update-props."priority.session" = 1200;
      }
      {
        matches = [ { "node.name" = "alsa_output.pci-0000_80_1f.3.analog-stereo"; } ];
        actions.update-props."priority.session" = 1100;
      }
    ];
  };

  # i18n
  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "ru_RU.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.extraLocaleSettings = {
    LC_TIME = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
  };

  console.keyMap = "us";

  # security
  security.sudo.enable = false;
  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "kirnik233899" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableUserSlices = true;
  };

  # users
  users.users.kirnik233899 = {
    isNormalUser = true;
    description = "kirnik233899";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "kvm"
      "libvirtd"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # login
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  # desktop
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri;
  services.xserver.enable = false;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    };
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  programs.dconf.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # fonts
  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.font-awesome
  ];

  # theme
  stylix = {
    enable = true;
    autoEnable = true;
    polarity = "dark";

    base16Scheme = "${pkgs.base16-schemes}/share/themes/darkviolet.yaml";
    override = {
      base04 = "7b43bf";
      base0B = "41d9bf";
      base0D = "326ee6";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 12;
        terminal = 12;
        desktop = 12;
        popups = 12;
      };
    };
  };

  # virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  # gaming
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode.enable = true;
  hardware.steam-hardware.enable = true;

  # packages
  environment.systemPackages = with pkgs; [
    aria2
    asciiquarium-transparent
    bat
    bemoji
    blender
    bottles
    brave
    brightnessctl
    cava
    cbonsai
    cmatrix
    curl
    duf
    dust
    eza
    fd
    file
    firefox
    gammastep
    gcc
    gimp
    git
    gnumake
    goverlay
    gptfdisk
    grim
    heroic
    htop
    imagemagick
    imv
    inkscape
    inxi
    jetbrains.pycharm
    libreoffice-stable
    lm_sensors
    lutris
    mangohud
    mpv
    mpvpaper
    neovim
    networkmanagerapplet
    nix-output-monitor
    nodejs
    nvme-cli
    obs-studio
    obsidian
    ouch
    p7zip
    parted
    pavucontrol
    pciutils
    pipes
    playerctl
    prismlauncher
    protontricks
    qalculate-gtk
    ripgrep
    rsync
    satty
    sing-box
    sl
    slurp
    smartmontools
    spotify
    telegram-desktop
    tmux
    tor-browser
    transmission_4-gtk
    tree
    udiskie
    unrar
    unzip
    usbutils
    vesktop
    vim
    vkbasalt
    vscodium
    wf-recorder
    wget
    winetricks
    wineWow64Packages.staging
    wl-clipboard
    xarchiver
    xwayland-satellite
    zathura
    zip
    zoom-us
  ];
}
