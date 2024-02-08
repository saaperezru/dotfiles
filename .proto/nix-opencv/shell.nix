with import <nixpkgs> {};
(

let python =
    let
    packageOverrides = self:
    super: {
      opencv4 = super.opencv4.override {
        enableGtk2 = true;
        gtk2 = pkgs.gtk2;
        enableFfmpeg = true;
        };
    };
    in
      pkgs.python311.override {inherit packageOverrides; self = python;};

in

pkgs.mkShell {
  buildInputs = [
    imagemagick
    v4l-utils
    opencv4
    poetry
    (python311.buildEnv.override {
      extraLibs = [
	pkgs.python311Packages.matplotlib
	pkgs.python311Packages.numpy
	pkgs.python311Packages.scipy
	pkgs.python311Packages.scikit-image
	pkgs.python311Packages.scikit-learn
	pkgs.python311Packages.gnureadline        
        python.pkgs.opencv4
      ];
      ignoreCollisions = true;
    })
  ];
  shellHook = ''
        # set SOURCE_DATE_EPOCH so that we can use python wheels
        SOURCE_DATE_EPOCH=$(date +%s)
        export LANG=en_US.UTF-8	
        alias ptp='python -m ptpython'
  '';
})

