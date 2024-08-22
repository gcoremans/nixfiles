{ lib, config, pkgs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "gilles.coremans@gmail.com";
      webroot = "/var/lib/acme/.challenges";
      group = "certs";
      reloadServices = [
        "haproxy.service"
      ];

      #server = "https://acme-staging-v02.api.letsencrypt.org/directory"; # For testing
    };
  };
}
