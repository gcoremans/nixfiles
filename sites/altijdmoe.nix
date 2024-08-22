{ lib, config, pkgs, ... }:
{
  imports = [ ./common.nix ];

  services.nginx.virtualHosts = {
    "altijd.moe" = {
      serverAliases = [ "*.altijd.moe" ];

      locations."/.well-known/acme-challenge" = {
        root = "/var/lib/acme/.challenges";
      };

      locations."/" = {
        root = "/var/www/altijd.moe";
      };
    };
  };

  security.acme.certs = {
    "altijd.moe" = {
      extraDomainNames = [
        "www.altijd.moe"
        "ik.ben.altijd.moe"
        "idm.altijd.moe"
        "auth.altijd.moe"
        "budget.altijd.moe"
      ];
    };
  };
}
