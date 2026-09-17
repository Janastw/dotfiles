{
  description = "dotfiles for Linux";

  inputs = {
    # Use stable Linux NixOS packages instead of macOS-darwin packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Use matching stable Home Manager release for Linux
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      # Your local Ubuntu username
      user = "thomas-janas";
      
      # Target architecture for standard Intel/AMD Linux computers
      system = "x86_64-linux"; 
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # This exposes the 'homeConfigurations' attribute that Nix on Ubuntu was looking for
      homeConfigurations."${user}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        
        # Passes the 'user' variable down to home.nix just like Kun's setup did
        extraSpecialArgs = { inherit user; };
        
        modules = [
          ./home.nix
        ];
      };
    };
}

