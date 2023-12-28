{ lib, config, pkgs, ... }:
{
  services.nginx.enable = true;

  security.acme = {
    acceptTerms = true;
    defaults.email = "gilles.coremans@gmail.com";
    defaults.group = "certs";
  };

  users.groups.certs.members = [ "nginx" ]; # Add OpenLDAP to the group that can read certs
}
