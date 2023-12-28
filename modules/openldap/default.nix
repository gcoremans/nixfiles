{ lib, config, pkgs, ... }:
{
  networking.hosts = { "127.0.0.1" = [ "altijd.moe" ]; };
  services.openldap = {
    enable = true;
    user = "openldap";

    urlList = [ "ldaps://altijd.moe" ];

    settings = {
      attrs = {
        olcLogLevel = "conns config";

        # Configure TLS
        # Note that we use the literal hostname here (lazy)
        olcTLSCACertificateFile = "/var/lib/acme/altijd.moe/full.pem";
        olcTLSCertificateFile = "/var/lib/acme/altijd.moe/cert.pem";
        olcTLSCertificateKeyFile = "/var/lib/acme/altijd.moe/key.pem";
        olcTLSCipherSuite = "HIGH:!MEDIUM:!LOW:!aNULL:!eNULL:!SSLv2:!SSLv3";
        olcTLSCRLCheck = "none";
        olcTLSVerifyClient = "never";
        olcTLSProtocolMin = "3.1";
      };

      children = {
        # Included schemas
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
        ];

        "olcDatabase={1}mdb".attrs = {
          objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];

          # Setup database
          olcDatabase = "{1}mdb";
          olcDbDirectory = "/var/lib/openldap/data";

          olcSuffix = "o=altijd.moe";

          # Setup LDAP root account
          olcRootDN = "cn=admin,o=altijd.moe";
          olcRootPW.path = pkgs.writeText "olcRootPW" "pass"; # TODO: change this

          olcAccess = [
            # For passwords only allow auth, and write for self
            ''{0}to attrs=userPassword
                by self write
                by anonymous auth
                by * none''

            # Allow read on anything else
            ''{1}to *
                by self write
                by * none''
          ];
        };
      };
    };
  };

  users.groups.acme.members = [ "openldap" ]; # Add OpenLDAP to the group that can read certs

}
