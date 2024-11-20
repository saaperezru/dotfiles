let
  pkgs2 = import (builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/8ad5e8132c5dcf977e308e7bf5517cc6cc0bf7d8.tar.gz";
        }) {};
pkgs = import <nixpkgs> {};
  name = "test";
  in pkgs.stdenv.mkDerivation {
    allowUnfree = true; 
    nativeBuildInputs = with pkgs.buildPackages; [
        gh gitui lazygit git-lfs
        docker docker-compose podman dive skopeo
        kubectl kubectx k9s kubent stern kubernetes-helm 
        pkgs2.fluxcd
        python39 poetry
    ];
    packages = [(pkgs.python39.withPackages (python-pkgs: [ 
                python-pkgs.pip
    ]))];
    inherit name;
    shellHook = ''
        source ~/.git-completion.bash
        source <(kubectl completion bash)
        source <(gh copilot alias -- bash)
    '';
}
