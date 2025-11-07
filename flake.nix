{
  description = "Hyprland implement caelestia";
  outputs =
    {
      nixpkgs,
      nixos-generators,
      caelestia-shell,
      ...
    }@inputs:
    let
      # System types to support.
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      forEachSystem = nixpkgs.lib.genAttrs systems;

      pkgsFor =
        system:
        (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            inputs.rust.overlays.default
            inputs.mac-style-plymouth.overlays.default
            (final: prev: {
              caelestia-shell = caelestia-shell.packages.${system}.caelestia-shell;
              caelestia-cli = caelestia-shell.inputs.caelestia-cli.packages.${system}.caelestia-cli;
            })
          ];
        });
      nixosBaseArgs = username: system: name: {
        inherit system;
        specialArgs = {
          inherit inputs;
          pkgs = pkgsFor system;
        };
        modules = [
          {
            networking.hostName = name;
            user.username = username;
          }
          ./home
          ./hosts/common
          inputs.home-manager.nixosModules.home-manager
        ]
        ++ [ ./hosts/${name}.nix ];
      };
      mkNixosCfg =
        username: system: name:
        nixpkgs.lib.nixosSystem (nixosBaseArgs username system name);

      genConfigs =
        username: names:
        map (
          system:
          nixpkgs.lib.listToAttrs (
            map (name: {
              name = name;
              value = mkNixosCfg username system name;
            }) names
          )
        ) systems;

      nixosGenerators =
        username: name: variants:
        forEachSystem (
          system:
          (nixpkgs.lib.listToAttrs (
            map (v: {
              name = v.name;
              value = nixos-generators.nixosGenerate (
                {
                  format = v.format;
                  # modules = [
                  #   { nix.registry.nixpkgs.flake = nixpkgs; }
                  # ];
                }
                // (nixosBaseArgs username system name)
              );
            }) variants
          ))
        );
    in
    {
      apps = forEachSystem (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          fmt = {
            type = "app";
            program = "${pkgs.writeShellScript "fmt-all" ''
              find . -name '*.nix' -type f -exec ${pkgs.nixfmt-rfc-style}/bin/nixfmt {} \;
            ''}";
          };
        }
      );

      packages = nixosGenerators "s4rch" "main" [
        {
          name = "vm";
          format = "vm";
        }
        {
          name = "iso";
          format = "install-iso";
        }
        {
          name = "iso-test";
          format = "iso";
        }
      ];

      # Contains full system builds, including home-manager
      # nixos-rebuild switch --flake .#main
      nixosConfigurations = genConfigs "s4rch" [ "main" ];
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # My plymouth theme
    mac-style-plymouth = {
      url = "github:SergioRibera/s4rchiso-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Used to generate NixOS images for other platforms
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    builders-use-substitutes = true;
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
