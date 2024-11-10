{ lib, config, pkgs, ... }:

let pkg = pkgs.stdenv.mkDerivation(finalAttrs: rec {
  pname = "actualbudget";
  version = "24.11.0";

  src = pkgs.fetchFromGitHub {
    owner = "actualbudget";
    repo = "actual-server";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-GwtJ42dBJXrOBIxwdrSvNeqQCl91m1XrtS3RBpEuZX0=";
  };

  # necessary because nix doesnt support modern yarn versions for some fucking reason
  yarnOfflineCache = pkgs.stdenv.mkDerivation { inherit src;
  name = "actualbudget-${version}-offline-cache";

    nativeBuildInputs = with pkgs; [
      yarn
      cacert # needed for git
      gitMinimal # needed to download git dependencies
      nodejs # needed for npm to download git dependencies
    ];

		ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn config set enableTelemetry 0

      echo "cacheFolder: \"$out\"" >> .yarnrc.yml
      yarn

      runHook postBuild
    '';

    dontConfigure = true;
    dontInstall = true;
    dontFixup = true;
  };

  #yarnBuildFlags = [ "--cache-folder ${yarnOfflineCache}" ];

  #yarnOfflineCache = pkgs.fetchYarnDeps {
  #  yarnLock = finalAttrs.src + "/yarn.lock";
  #};

  nativeBuildInputs = with pkgs; [
    unstable.yarnConfigHook
    unstable.yarnBuildHook
    nodejs
    npmHooks.npmInstallHook
  ];

  #pkgConfig.sqlite3 = {
  #  nativeBuildInputs = with pkgs; [
  #    node-pre-gyp
  #    python3
  #    sqlite
  #  ];
  #  postInstall = ''
  #    export CPPFLAGS="-I${pkgs.nodejs}/include/node"
  #    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${pkgs.nodejs}/include/node --sqlite=${pkgs.sqlite.dev}
  #    rm -r build-tmp-napi-v6
  #  '';
  #};

  #pkgConfig.bcrypt = {
  #  nativeBuildInputs = with pkgs; [
  #    node-pre-gyp
  #    python3
  #  ];
  #  postInstall = ''
  #    export CPPFLAGS="-I${pkgs.nodejs}/include/node"
  #    node-pre-gyp install --prefer-offline --build-from-source --nodedir=${pkgs.nodejs}/include/node
  #  '';
  #};

  postInstall = ''
    makeWrapper '${pkgs.nodejs}/bin/node' '$out/bin/actualbudget' \
      --add-flags "$out/libexec/actualbudget/deps/actualbudget/lib/app.js"
      --set NODE_ENV production
  '';
  }); in
{
  systemd.services.actualbudget = {
    description = "Actual Budget - open source envelope budgeting";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkg}/bin/actualbudget";
      #ExecStartPre = [  ];
      StateDirectory = "actualbudget";
      StateDirectoryMode = "0700";
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      User = "actualbudget";
      Restart = "on-failure";
    };
  };

  users = {
    users.actualbudget = {
      group = "actualbudget";
      isSystemUser = true;
    };
    groups.actualbudget = { };
  };
}
