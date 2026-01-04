{ config, pkgs, ... }:

{
  imports = [
    ./hardware/laptop.nix
    ./common.nix
  ];

  networking.hostName = "laptop";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Fix lid closure behavior
  services.logind.settings.Login = {
    HandleLidSwitch = "hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
  ];

  # Specify encrypted disk partition id
  boot.initrd.luks.devices."luks-198aef4c-3bd7-4efd-bcd9-bbf207d06b4a".device = "/dev/disk/by-uuid/198aef4c-3bd7-4efd-bcd9-bbf207d06b4a";

  # Enable nouveau
  hardware.graphics = {
    enable = true;
  };

  # Adds some fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

}