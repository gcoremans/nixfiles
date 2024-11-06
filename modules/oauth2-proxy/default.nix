{ lib, config, pkgs, ... }:
{
  services.oauth2-proxy = {
    enable = true;

    httpAddress = "http://127.0.0.1:8442";
    keyFile = "/var/oauth2-proxy-secrets";

    reverseProxy = true;
    setXauthrequest = true;

    provider = "oidc";
    clientID = "oauth2-proxy";
    scope = "openid email profile";
    oidcIssuerUrl = "https://idm.altijd.moe/oauth2/openid/oauth2-proxy";
    redeemURL = "https://idm.altijd.moe/oauth2/token";
    loginURL = "https://idm.altijd.moe/oauth2/authorise";
    redirectURL = "https://auth.altijd.moe/oauth2/callback";

    cookie.domain = ".altijd.moe";
    cookie.expire = "72h0m0s";
    cookie.refresh = "4h0m0s";

    email.domains = [ "*" ];

    extraConfig = {
      code-challenge-method = "S256";
    };
  };

  security.acme.certs = {
    "altijd.moe" = {
      extraDomainNames = [ "auth.altijd.moe" ];
    };
  };
}
