{
  lib,
  stdenvNoCC,
  fetchurl,
}:
let
  version = "0.13.4";
  # Hashes from https://terminal-browser.sh/install (the upstream install script)
  sources = {
    aarch64-darwin = {
      target = "darwin-arm64";
      hash = "sha256-8BcjDHjGCgfvRFGh6wqScn8LlVqPzYeuw1iRDF0MA8c=";
    };
    x86_64-darwin = {
      target = "darwin-x64";
      hash = "sha256-AbxpkbrRIvQuTypRZKGY2DhLlEwDbeESB4/VH1jcZ+0=";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "terminal-browser: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "terminal-browser";
  inherit version;

  src = fetchurl {
    url = "https://terminal-browser.sh/install/dl/stable/v${version}/terminal-browser-${source.target}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = "terminal-browser";

  # The tarball carries AppleDouble `._*` files; GNU tar unpacks them as real
  # files, which breaks the Electron bundle's code signature.
  postUnpack = ''
    find $sourceRoot -name '._*' -delete
  '';

  # Prebuilt, code-signed Electron bundle: leave the binaries untouched.
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/terminal-browser $out/bin
    cp -R . $out/share/terminal-browser
    # The launcher resolves its own symlink to find the bundle root.
    ln -s $out/share/terminal-browser/bin/terminal-browser $out/bin/terminal-browser
    runHook postInstall
  '';

  meta = {
    description = "A real browser inside your terminal";
    homepage = "https://github.com/zenbu-labs/terminal-browser";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = builtins.attrNames sources;
    mainProgram = "terminal-browser";
  };
}
