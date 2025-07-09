{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    packages = [(pkgs.python311.withPackages (python-pkgs: [ 
                python-pkgs.matplotlib
                python-pkgs.plotly
                python-pkgs.numpy
                python-pkgs.pandas
                python-pkgs.statsmodels 
                python-pkgs.sympy
                python-pkgs.scipy
                python-pkgs.altair
                python-pkgs.seaborn
                python-pkgs.prophet
    ]))];
    buildInputs = with pkgs.buildPackages; [ python313 poetry ];
    shellHook = ''
        alias ptp='python -m ptpython'
    '';
}
