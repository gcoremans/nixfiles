{ lib, config, pkgs, ... }:
{
  imports = [ ../oauth2-proxy/default.nix ];

  services.haproxy = {
    package = pkgs.unstable.haproxy;
    enable = true;
    config = lib.concatLines [
      ''
      global
        lua-prepend-path ${./lua}/?.lua
        lua-load ${./lua}/auth-request.lua
        lua-load ${./lua}/cors.lua

      ''
      (builtins.readFile ./haproxy.cfg)
    ];
  };

  users.groups.certs.members = [ "haproxy" ];
}
