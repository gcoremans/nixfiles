{ lib, config, pkgs, ... }:
{
  imports = [ ../modules/nginx
              ../modules/acme ];
}
