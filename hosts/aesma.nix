{ inputs, outputs, authorizedKeys, modulesPath, lib, config, pkgs, ... }:
{
  networking.hostName = "aesma";
  system.stateVersion = "24.05";

  imports =
    [ (modulesPath + "/profiles/qemu-guest.nix")
    ];

  users.users = {
    root = {
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.settings.PermitRootLogin = "prohibit-password";

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  networking.useDHCP = lib.mkDefault true;
}
