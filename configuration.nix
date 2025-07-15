# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.artaud = {
    isNormalUser = true;
    description = "artaud";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install various programs
  programs.firefox.enable = true;
  programs.gpaste.enable = true;
  programs.zsh.enable = true;

  # Change the default shell to zsh
  users.defaultUserShell = pkgs.zsh; 

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch
    git
    protonvpn-gui
    tor-browser
    vscodium
    neovim
    tectonic
    ollama
    btop
    uv
    gnupg
    kitty
    zotero
    libreoffice
    vscode
    spotify-player
    inkscape
    pidgin
    newsboat
    kdePackages.kleopatra
    gnomeExtensions.pop-shell
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.rounded-window-corners-reborn
  ];

  # Set bootloader to remember and use the most recent version
  boot.loader.grub.default = "saved";
  boot.loader.grub.extraConfig = ''
    set default=0
  '';

  # Enable glance service
  services.glance.enable = true;
  services.glance.settings = {
    pages = [
      
      {
        columns = [
          {
            size = "small";
            widgets = [
              {
                type = "calendar";
              }
              {
                location = "West Lafayette, United States";
                type = "weather";
                units = "imperial";
              }
            ];
          }
          {
            size = "full";
            widgets = [
              {
                type = "rss";
                title = "Materials Science Journals";
                limit = 12;
                feeds = [
                  {
                    url = "https://rss.sciencedirect.com/publication/science/09270256";
                    title = "Computational Materials Science";
                  }
                  {
                    url = "https://www.nature.com/npjcompumats.rss";
                    title = "npj Computational Materials";
                  }
                  {
                    url = "https://www.nature.com/nmat.rss";
                    title = "Nature Materials";
                  }
                  {
                    url = "https://www.mdpi.com/rss/journal/materials";
                    title = "Materials (MDPI)";
                  }
                  {
                    url = "https://arxiv.org/rss/cond-mat.mtrl-sci";
                    title = "arXiv Materials Science";
                  }
                  {
                    url = "https://arxiv.org/rss/physics.comp-ph";
                    title = "arXiv Computational Physics";
                  }
                ];
              }
            ];
          }
          {
            size = "small";
            widgets = [
              {
                type = "rss";
                title = "Academic Resources";
                feeds = [
                  {
                    url = "https://huggingface.co/blog/feed.xml";
                    title = "Hugging Face Blog";
                  }
                  {
                    url = "https://katnykiel.github.io/blog/index.xml";
                    title = "Kat Nykiel Blog";
                  }
                  {
                    url = "https://www.rcac.purdue.edu/news/rss/Outages%20and%20Maintenance";
                    title = "RCAC Maintenance";
                  }
                ];
              }
              {
              type = "releases";
              title = "software releases";
              repositories = [
                "materialsproject/pymatgen"
                "materialsproject/atomate2"
                "mir-group/nequip"
                "autoatml/autoplex"
                "deepmodeling/dpdata"
                "materialsproject/custodian"
                "materialsproject/jobflow"
                "materialsproject/maggma"
              ];
            }
            ];
          }
        ];
        name = "academia";
      }
    ];
    server = {
      port = 5678;
    };
  };

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable syncthing
  services = {
    syncthing = {
        enable = true;
        group = "users";
        user = "artaud";
        dataDir = "/home/artaud/Documents";    # Default folder for new synced folders
        configDir = "/home/artaud/Documents/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };

  # Install the driver
  services.fprintd.enable = true;

  # # Enable hyprland
  # programs.hyprland = {
  #   # Install the packages from nixpkgs
  #   enable = true;
  #   # Whether to enable XWayland
  #   xwayland.enable = true;
  # };

  # # Enable waybar
  # programs.waybar = {
  #   enable = true;
  # };

  # # Adds some fonts
  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  #   nerd-fonts.droid-sans-mono
  # ];

#   # Try to extend battery life beyond gnome defaults
#   services.power-profiles-daemon.enable = false;
#   powerManagement.enable = true;
#   services.thermald.enable = true;

#   services.tlp = {
#       enable = true;
#       settings = {
#         CPU_SCALING_GOVERNOR_ON_AC = "performance";
#         CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

#         CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
#         CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

#         CPU_MIN_PERF_ON_AC = 0;
#         CPU_MAX_PERF_ON_AC = 100;
#         CPU_MIN_PERF_ON_BAT = 0;
#         CPU_MAX_PERF_ON_BAT = 20;

#        #Optional helps save long term battery health
#        START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
#        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

#       };
# };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
