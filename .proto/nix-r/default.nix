{ pkgs ? import <nixpkgs> {   } }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs.buildPackages; [ 
        R
        rPackages.data_table
        rPackages.dplyr
        rPackages.ggplot2
        rPackages.tidyverse
        rPackages.tidymodels 
        rPackages.learnr
        rPackages.shiny
    ];
}
