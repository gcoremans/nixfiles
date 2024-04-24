{ lib, config, pkgs, ... }:
{
  systemd.services.vouch-proxy = {
    description = "Authentication proxy service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target"];

    serviceConfig = {
      Type = "simple";
      User = "vouch-proxy";
      ExecStart = "${pkgs.vouch-proxy}/bin/vouch-proxy";
      Restart = "on-failure";
      RestartSec = 5;
      StartLimitInterval = "60s";
      StartLimitBurst = 3;
    };
  };
}
