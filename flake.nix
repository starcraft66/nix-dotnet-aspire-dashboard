{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { nixpkgs, flake-parts, ... }@inputs: flake-parts.lib.mkFlake { inherit inputs; } {
    imports = [
      inputs.flake-parts.flakeModules.easyOverlay
    ];
    perSystem = { config, self', inputs', pkgs, system, ... }:
      with pkgs;
      let
        aspire-dashboard = callPackage ./default.nix { };
      in
      {
        packages.default = aspire-dashboard;
        overlayAttrs = {
          inherit (config.packages) aspire-dashboard;
        };
        packages.aspire-dashboard = aspire-dashboard;
        apps.aspire-dashboard = {
          type = "app";
          program = "${self'.packages.aspire-dashboard}/bin/Aspire.Dashboard";
        };
      };
    systems = nixpkgs.lib.systems.flakeExposed;
  };
}


