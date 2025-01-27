{ lib, config, pkgs, ... }:
{
  environment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;

    vendor.completions.enable = true;
    vendor.config.enable = true;
    vendor.functions.enable = true;

    shellInit = ''
      set fish_greeting ""
      set -p fish_function_path /etc/fish/functions
    '';

    shellAbbrs = {
      dd = "dd bs=256K status=progress";
      py = "python3";
      ss = "ss -ptua";
    };

    #shellAliases = {
    #  vim = "nvim";
    #};
  };

  environment.etc = {
    "fish/functions".source = ./config/functions;
  };
}
