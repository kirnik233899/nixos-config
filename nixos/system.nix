{ pkgs, inputs, ... }: {
  # secrets
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

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
  hardware.bluetooth.enable = true;
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
  niri-flake.cache.enable = false;

  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.problems.handlers."gtk+".broken = "warn";

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

  services.i2pd.enable = true;

  # audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."51-output-priority" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "node.name" = "~alsa_output.usb-Razer_Razer_Kraken_V3_HyperSense.*analog-stereo"; } ];
        actions.update-props."priority.session" = 1200;
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

  xdg.portal = {
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
    };
  };

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.udisks2.enable = true;
  services.flatpak.enable = true;

  # fonts
  fonts.packages = [
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-cjk-serif
    pkgs.font-awesome
  ];

  # theme
  stylix = {
    enable = true;
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
    cava
    cbonsai
    cmatrix
    curl
    duf
    dust
    eza
    fd
    file
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
    nodejs
    nvme-cli
    obs-studio
    obsidian
    ouch
    p7zip
    pavucontrol
    pciutils
    pipes
    prismlauncher
    protontricks
    qalculate-gtk
    ripgrep
    rsync
    satty
    sl
    slurp
    smartmontools
    spotify
    telegram-desktop
    tmux
    tor-browser
    transmission_4-gtk
    unrar
    unzip
    usbutils
    vesktop
    vim
    vkbasalt
    vscodium
    wf-recorder
    winetricks
    wineWow64Packages.staging
    wl-clipboard
    xwayland-satellite
    zathura
    zip
    zoom-us
  ];
}
