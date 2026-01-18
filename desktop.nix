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

  networking.hostName = "desktop";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow an unstable derivative
  nixpkgs.config = {
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
    code-cursor
    discord
    openrgb
    spotify
    unstable.ollama-cuda
    vscode
  ];

  # Enable ollama service
  services.ollama = {
    enable = true;
    port = 11435;
    acceleration = "cuda";
  };

  # Disable suspend
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;
  powerManagement.enable = false;

  # Enable openrgb
  services.hardware.openrgb.enable = true;

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
