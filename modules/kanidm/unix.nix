{ lib, config, pkgs, ... }:
let rootdomain = "altijd.moe"; in {
  services.kanidm = {
    enablePam = true;
    unixSettings = {
      #pam_allowed_login_groups = "" #TODO
    };
  };

  imports = [ ./client.nix ];
}
