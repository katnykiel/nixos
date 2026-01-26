# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable automatic updates
  system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;

  # Enable 'experimental' features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable networking
  networking.networkmanager.enable = true;
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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.artaud = {
    isNormalUser = true;
    description = "artaud";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Change the default shell to zsh
  users.defaultUserShell = pkgs.zsh; 

  # Install various programs
  programs.firefox.enable = true;
  programs.gpaste.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    fastfetch
    git
    gnomeExtensions.night-theme-switcher
    gnomeExtensions.pop-shell
    gnomeExtensions.rounded-window-corners-reborn
    gnupg
    kdePackages.kleopatra
    keymapp
    kitty
    libreoffice
    ncdu
    neovim
    newsboat
    pidgin
    protonvpn-gui
    signal-desktop
    spotify-player
    tectonic
    tinymist
    tor-browser
    typst
    uv
    vim
    vscodium
    weechat
    wget
    zip
    zotero
  ];

  # Enable ZSA keyboard support
  hardware.keyboard.zsa.enable = true;

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
              { type = "bookmarks";
                groups = [
                  {
                    links = [
                      {
                        url = "https://katnykiel.atlassian.net/jira/software/projects/KAT/boards/1";
                        title = "jira";
                      }
                      {
                        url = "https://app.slack.com/client/T02HLBU8A3E";
                        title = "slack";
                      }
                      {
                        url = "https://outlook.office.com/mail/inbox/id/AAQkADIxYTZkYTdiLWVkNDktNDViMS05NjBmLWE5M2RiMmIxZjhkMQAQAIKwDotMs%2BNJs8PRRKdjI2M%3D";
                        title = "outlook";
                      }
                    ];
                  }
                ];
              }
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
                feeds = [
                  {
                    url = "https://www.nature.com/npjcompumats.rss";
                    title = "npj Computational Materials";
                  }
                  {
                    url = "https://www.nature.com/nmat.rss";
                    title = "Nature Materials";
                  }
                  {
                    url = "https://arxiv.org/rss/cond-mat.mtrl-sci";
                    title = "arXiv Materials Science";
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
                "materialsproject/custodian"
                "materialsproject/jobflow"
                "materialsproject/maggma"
                "hackingmaterials/amset"
                "materialsvirtuallab/matgl"
                "materialsproject/fireworks"
                "materialsproject/api"
                "materialsproject/emmet"
                "materialsproject/crystaltoolkit"
              ];
            }
            ];
          }
        ];
        name = "glance";
      }
    ];
    server = {
      port = 5678;
    };
  };

  # Enable docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
