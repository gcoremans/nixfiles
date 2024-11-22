{ lib, config, pkgs, ... }:
{
  imports = [ ./common.nix ];

  services.nginx.virtualHosts = {
    "operand.be" = {
      serverAliases = [ "*.operand.be" ];

      locations."/.well-known/acme-challenge" = {
        root = "/var/lib/acme/.challenges";
      };

      locations."/" = {
        root = "/var/www/operand.be";
      };
    };
  };

  security.acme.certs = {
    "operand.be" = {
      extraDomainNames = [
        "www.operand.be"
      ];
    };
  };
}
