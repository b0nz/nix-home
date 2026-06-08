{ pkgs, ... }:

let
  opencode-ai = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "opencode-ai";
    version = "1.16.2";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/opencode-linux-x64/-/opencode-linux-x64-${version}.tgz";
      hash = "sha256-oi35alYuZ84kR0bZkFbsrJ5m3fjmnI15iH4dYw9NnDE=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeBinaryWrapper
      pkgs.writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      tar xzf $src
      install -Dm755 package/bin/opencode $out/bin/opencode

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/opencode \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.ripgrep ]}
    '';

    nativeInstallCheckInputs = [
      pkgs.writableTmpDirAsHomeHook
    ];
    doInstallCheck = true;
    installCheckPhase = ''
      $out/bin/opencode --version | grep -q "${version}"
    '';
  };
in
{
  home.packages = [ opencode-ai ];
}
