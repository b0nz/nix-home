{ pkgs, ... }:

let
  opencode-ai = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "opencode-ai";
    version = "1.17.0";

    src = pkgs.fetchurl {
      url = "https://registry.npmjs.org/opencode-linux-x64/-/opencode-linux-x64-${version}.tgz";
      hash = "sha256-rVJj55HJ44K9zdSmhtI1w4QglJRvBpSN3cHwMq7/wRQ=";
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
