{ lib, config, pkgs, ... }:
{
  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "gilles.coremans@gmail.com";
  };
}
