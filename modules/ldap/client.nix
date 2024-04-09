{ lib, config, pkgs, ... }:
{
  users.ldap = {
    enable = true;
    server = "ldaps://altijd.moe";
    base = "o=altijd.moe";

    # Disable LDAP auth for users for now
    nsswitch = false;
    loginPam = false;
  };
}
