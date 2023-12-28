{ lib, config, pkgs, ... }:
{
  imports = [ ../modules/nginx ];

  services.nginx.virtualHosts = {
    "operand.be" = {
      addSSL = true;
      enableACME = true;

      serverAliases = [ "www.operand.be" ];

      root = "/var/www/operand.be";

      locations."/notes/" = {
        extraConfig = "autoindex on;";
      };
    };
  };
}
