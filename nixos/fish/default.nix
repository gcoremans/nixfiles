{ lib, config, pkgs, ... }:
{
  environment.shells = [ pkgs.fish ];

  programs.fish = {
    enable = true;

    vendor.completions.enable = true;
    vendor.config.enable = true;

    shellAbbrs = {
      dd = "dd bs=256K status=progress";
      py = "python3";
      ss = "ss -ptua";
    };
  };

  environment.etc.fish = {
    source = ./config;
  };
}
