{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
  nodejs_24,
}:
buildNpmPackage rec {
  pname = "rea-agents";
  version = "6.8.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${version}.tgz";
    hash = "sha256-jVQux2qcs1BYS2CmycCIcG/4EtW7WwlMIMlbbcJWmLs=";
  };

  nodejs = nodejs_24;

  # The npm tarball ships no lockfile. Regenerate on version bump:
  #   tar xzf rea-agents-<ver>.tgz && cd package
  #   jq 'del(.devDependencies) | del(.scripts.prepare, .scripts.prepack)' package.json > p && mv p package.json
  #   npm install --package-lock-only --ignore-scripts
  postPatch = ''
    ${lib.getExe jq} 'del(.devDependencies) | del(.scripts.prepare, .scripts.prepack)' package.json > package.json.new
    mv package.json.new package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-XsCQF6ZzgmAhWkgFsRBc4ymzfYdldqkyEDSJ89qgMSM=";

  dontNpmBuild = true;

  # The optional `frida` dep downloads a prebuilt binding at install time,
  # which the sandbox forbids; frida-based dynamic instrumentation is unavailable.
  npmRebuildFlags = [ "--ignore-scripts" ];

  meta = {
    description = "Reverse Engineer Anything: reverse-engineering tools for coding agents";
    homepage = "https://rea.tools";
    license = lib.licenses.mit;
    mainProgram = "rea";
  };
}
