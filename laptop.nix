{ config, pkgs, ... }:

{
  imports = [
    ./hardware/laptop.nix
    ./common.nix
  ];

  networking.hostName = "laptop";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    btop
  ];

  # Suspend first then hibernate when closing the lid
  services.logind.settings.Login.HandlelidSwitch = "suspend-then-hibernate";
  # Hibernate on power button pressed
  services.logind.settings.Login.HandlepowerKey = "suspend";
  services.logind.settings.Login.HandlePowerKeyLongPress = "poweroff";

  # Specify encrypted disk partition id
  boot.initrd.luks.devices."luks-198aef4c-3bd7-4efd-bcd9-bbf207d06b4a".device = "/dev/disk/by-uuid/198aef4c-3bd7-4efd-bcd9-bbf207d06b4a";
  
  # Adds some fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

}