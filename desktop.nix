{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in

{
  imports = [
    ./hardware/desktop.nix
    ./common.nix
  ];

  # Use LTS kernel.
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  networking.hostName = "desktop";

  # Allow unfree and unstable derivative
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

    # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop-cuda
    claude-code
    jdk25
    keymapp
    openrgb
    prism-launcher
    spotify
    unstable.ollama-cuda
    vscode
  ];

  # Enable ollama service
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    package = pkgs.unstable.ollama-cuda;
  };

  # Enable openrgb
  services.hardware.openrgb.enable = true;

  # Enable openssh
  services.openssh = {
    enable = true;
    ports = [ 51234 ];
    settings = {
      PasswordAuthentication = false;   # optional (disable if using keys only)
      PermitRootLogin = "no";
    };
  };
  networking.firewall.allowedTCPPorts = [ 51234 ];

  # Enable fail2ban to protect against brute-force attacks on SSH
  services.fail2ban = {
    enable = true;
    jails = {
      sshd = {
        settings = {
          enabled = true;
          port = "51234";
          filter = "sshd";
          logpath = "/var/log/auth.log";
          maxretry = 5;
          findtime = "10m";
          bantime = "1h";
        };
      };
    };
  };

  # Disable the GNOME3/GDM auto-suspend feature that cannot be disabled in GUI!
  # If no user is logged in, the machine will power down after 20 minutes.
  services.displayManager.gdm.autoSuspend = false;
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;


  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Specify encrypted disk partition id
  boot.initrd.luks.devices."luks-29f1033f-b941-47c9-82cf-61b8672b2f58".device = "/dev/disk/by-uuid/29f1033f-b941-47c9-82cf-61b8672b2f58";

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    # Enable the Nvidia settings menu,
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

   };
  
}
