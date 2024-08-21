{ lib, config, pkgs, ... }:
{
  imports = [ ../oauth2-proxy/default.nix ];

  services.haproxy = {
    enable = true;
    config = lib.concatLines [
      ''
      global
        lua-load ${./http.lua}
        lua-load ${./auth-request.lua}

      ''
      ./haproxy.cfg
    ];
  };

  users.groups.certs.members = [ "haproxy" ];
}
