{ lib, config, pkgs, ... }:
{
  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "gilles.coremans@gmail.com";
    defaults.group = "certs"; /* Group so other services can read certs if necessary */
  };
}
