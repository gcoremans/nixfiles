{ lib, config, pkgs, ... }:
{
  services.oauth2-proxy = {
    enable = true;

    httpAddress = "http://127.0.0.1:8442";
    keyFile = "/var/oauth2-proxy-secrets";

    reverseProxy = true;
    setXauthrequest = true;

    provider = "oidc";
    clientID = "altijdmoe_auth";
    scope = "openid email profile groups";
    oidcIssuerUrl = "https://idm.altijd.moe/oauth2/openid/altijdmoe_auth";

    cookie.domain = ".altijd.moe";
    cookie.expire = "72h0m0s";
    cookie.refresh = "4h0m0s";

    email.domains = [ "*" ];

    extraConfig = {
      code-challenge-method = "S256";
      whitelist-domain = ".altijd.moe";
    };
  };

  security.acme.certs = {
    "altijd.moe" = {
      extraDomainNames = [ "auth.altijd.moe" ];
    };
  };
}
