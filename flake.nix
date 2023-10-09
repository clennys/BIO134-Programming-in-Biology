{
  description = "An FHS shell with conda";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      # Conda installs it's packages and environments under this directory
      installationPath = "/home/dhuber/.conda";

	in {
      devShell.x86_64-linux = (pkgs.buildFHSUserEnv {
        name = "conda";
        targetPkgs = pkgs: (
          with pkgs; [
            autoconf
            binutils
            conda
			black
			pyright
            curl
            freeglut
            gcc11
            gnumake
            gnupg
            gperf
            libGLU libGL
            libselinux
            m4
            ncurses5
            procps
            stdenv.cc
            unzip
            util-linux
            wget
			spyder
			python311Packages.jupyterlab
			# python311Packages.jupyterlab-lsp
          ]
        );
        profile = ''
          # conda
          export PATH=${installationPath}/bin:$PATH
          # Paths for gcc if compiling some C sources with pip
          export NIX_CFLAGS_COMPILE="-I${installationPath}/include"
          export NIX_CFLAGS_LINK="-L${installationPath}lib"
          # Some other required environment variables
        '';
      }).env;
    };
}
