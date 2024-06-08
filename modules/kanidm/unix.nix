{ lib, config, pkgs, ... }:
let rootdomain = "altijd.moe"; in {
  imports = [ ./client.nix ];

  services.kanidm = {
    enablePam = true;
    unixSettings = {
      #pam_allowed_login_groups = "" #TODO
    };
  };
}
