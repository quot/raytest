{
  description = "Zig Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        nativeBuildInputs = with pkgs; [
          zig
          zls
        ];

        buildInputs = with pkgs; [ libGL xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXinerama xorg.libXi ];
      in {
        devShells.default = pkgs.mkShell {inherit nativeBuildInputs buildInputs;};

        packages.default = pkgs.stdenv.mkDerivation {
          pname = "template";
          version = "0.0.0";
          src = ./.;

          nativeBuildInputs =
            nativeBuildInputs
            ++ [
              pkgs.zig.hook
            ];
          inherit buildInputs;
        };
      }
    );
}
