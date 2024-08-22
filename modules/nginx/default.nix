{ lib, config, pkgs, ... }:
{
  services.nginx = {
    enable = true;
    defaultSSLListenPort = 2443;
    defaultHTTPListenPort = 2080;
    defaultListenAddresses = [ "127.0.0.1" ];
  };

  users.groups.certs.members = [ "nginx" ];
}
