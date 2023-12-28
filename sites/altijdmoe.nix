{ lib, config, pkgs, ... }:
{
  imports = [ ../modules/nginx ];

  services.nginx.virtualHosts = {
    "altijd.moe" = {
      addSSL = true;
      enableACME = true;

      serverAliases = [ "www.altijd.moe"
                        "ik.ben.altijd.moe" ];

      root = "/var/www/altijd.moe";
    };
  };

  security.acme.certs = {
    "altijd.moe" = {
      group = "certs";
    };
  };
}
