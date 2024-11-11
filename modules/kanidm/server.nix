{ lib, config, pkgs, ... }:
let rootdomain = "altijd.moe"; in {
  services.kanidm = {
    enableServer = true;
    serverSettings = {
      bindaddress = "127.0.0.1:8443";
      domain = "idm.${rootdomain}";
      origin = "https://idm.${rootdomain}:443";
      tls_chain = "/var/lib/acme/${rootdomain}/fullchain.pem";
      tls_key = "/var/lib/acme/${rootdomain}/key.pem";

      online_backup = {}; #TODO
    };
  };

  users.groups.certs.members = [ "kanidm" ];

  security.acme.certs = {
    "${rootdomain}" = {
      extraDomainNames = [ "idm.${rootdomain}" ];
    };
  };

  systemd.services.kanidm.serviceConfig = {
    StateDirectory = lib.mkForce "kanidm kanidm/backups";
  };
}
