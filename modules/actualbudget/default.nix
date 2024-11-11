{ lib, config, pkgs, ... }:
{
  virtualisation.oci-containers.containers.actualbudget = {
    image = "actualbudget/actual-server:latest-alpine";
    ports = [ "127.0.0.1:5006:5006" ];
    volumes = [ "/var/lib/actualbudget:/data" ];
    environment = {
      ACTUAL_LOGIN_METHOD = "header";
      #ACTUAL_HTTPS_KEY = /data/selfhost.key;
      #ACTUAL_HTTPS_CERT = /data/selfhost.crt;
      #ACTUAL_PORT = 5006;
      #ACTUAL_UPLOAD_FILE_SYNC_SIZE_LIMIT_MB = 20;
      #ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SYNC_SIZE_LIMIT_MB = 50;
      #ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB = 20;
    };
  };

  systemd.services.podman-actualbudget.serviceConfig = {
    StateDirectory = "actualbudget";
  };
}
