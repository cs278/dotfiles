{
  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-24.11";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ...
  }@inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-linux"];
    forEachSystem = f: lib.genAttrs systems (sys: f pkgsFor.${sys});
    pkgsFor = nixpkgs.legacyPackages;
  in {
    inherit lib;

    nixosConfigurations = {
      mercury = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/mercury/configuration.nix ];
        specialArgs = { inherit inputs outputs; };
      };
    };

#    homeConfigurations = {
#      "chris@mercury" = lib.homeManagerConfiguration {
#        modules = [ ./hosts/mercury/home.nix ];
#        pkgs = nixpkgs.legacyPackages.x86_64-linux;
#        extraSpecialArgs = { inherit inputs outputs; };
#      };
#    };
  };
}
