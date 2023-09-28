{ inputs, outputs, authorizedKeys, lib, config, pkgs, ... }:
{
  networking.hostName = "nyave";
  system.stateVersion = "23.05";

  users.users = {
    root = {
      openssh.authorizedKeys.keys = authorizedKeys;
    };
  };

  services.openssh.permitRootLogin = "yes";
  nixpkgs.hostPlatform = "aarch64-linux";
}
