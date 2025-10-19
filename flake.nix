{
  description = "claudebox - A macOS sandbox wrapper for Claude Code";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.claudebox;
          
          claudebox = pkgs.stdenv.mkDerivation {
            pname = "claudebox";
            version = "0.1";
            
            src = ./.;
            
            buildInputs = with pkgs; [
              bash
            ];
            
            installPhase = ''
              mkdir -p $out/bin
              cp claudebox $out/bin/claudebox
              chmod +x $out/bin/claudebox
            '';
            
            meta = with pkgs.lib; {
              description = "A macOS sandbox wrapper for Claude Code that provides secure, isolated execution environments";
              homepage = "https://github.com/greitaskodas/claudebox";
              license = licenses.mit;
              maintainers = [ ];
              platforms = platforms.darwin; # macOS only since it uses sandbox-exec
            };
          };
        };
        
        apps = {
          default = self.apps.${system}.claudebox;
          
          claudebox = flake-utils.lib.mkApp {
            drv = self.packages.${system}.claudebox;
            name = "claudebox";
          };
        };
        
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            bash
            shellcheck
          ];
          
          shellHook = ''
            echo "claudebox development environment"
            echo "Available commands:"
            echo "  ./claudebox        - Run claudebox"
            echo "  shellcheck claudebox - Check shell script"
          '';
        };
      }
    );
}