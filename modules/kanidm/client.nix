{ lib, config, pkgs, ... }:
let rootdomain = "altijd.moe"; in {
  services.kanidm = {
    enableClient = true;
    clientSettings.uri = "https://idm.${rootdomain}:443";
  };
  environment.systemPackages = with pkgs; [
    kanidm
  ];
}

