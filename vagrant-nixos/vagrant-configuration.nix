{ config, pkgs, ... }:

{
  imports = [ ];

  boot.loader.grub.device = "/dev/sda";
  services.openssh.enable = true;
  security.sudo.wheelNeedsPassword = false;
  users.users = {
    root.password = "vagrant";
    vagrant = {
      isNormalUser = true;
      password = "vagrant";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };
}
