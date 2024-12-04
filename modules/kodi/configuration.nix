{ lib, config, pkgs, ... }:
{
  services.cage.user = "kodi";
  services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
  services.cage.enable = true;

  users.users.kodi = {
    password = "";
    linger = true;
    isNormalUser = true;
    createHome = true;
  };

  nixpkgs.config.kodi.enableAdvancedLauncher = true;

  environment.systemPackages = [
    (pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [
      # Uses python in nativeBuildInputs for some reason, which causes crosscompile to fail
      jellyfin.override { buildInputs = [ pkgs.python3.withPackages (p: with p; [ pyyaml ]) ];
                          nativeBuildInputs = [  ]; }
      sendtokodi
      youtube
    ]))

    pkgs.moonlight-embedded
  ];

  # Remote control ports
  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
