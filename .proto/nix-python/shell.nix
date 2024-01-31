{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    buildInputs = with pkgs.buildPackages; [ python310 python310Packages.matplotlib python310Packages.numpy python310Packages.pandas python310Packages.statsmodels python310Packages.scipy python310Packages.seaborn poetry ];
}
