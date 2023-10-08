{ lib, config, pkgs, ... }:
{
  programs.ssh = {
    startAgent = true;
    extraConfig = "AddKeysToAgent yes";
  };
}
