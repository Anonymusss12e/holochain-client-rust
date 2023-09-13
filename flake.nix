{
  inputs = {
    nixpkgs.follows = "holonix/nixpkgs";
    versions.url = "github:holochain/holochain/nix/fix-and-pin-lair-0.3.0-input?dir=versions/0_2";
    holonix.url = "github:holochain/holochain/nix/fix-and-pin-lair-0.3.0-input";
    holonix.inputs.versions.follows = "versions";
  };

  outputs = inputs@{ holonix, ... }:
    holonix.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # provide a dev shell for all systems that the holonix flake supports
      systems = builtins.attrNames holonix.devShells;

      perSystem = { config, system, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            inputsFrom = [ holonix.devShells.${system}.holochainBinaries ];
            packages = with pkgs; [
              # add further packages from nixpkgs
            ];
          };
        };
    };
}
