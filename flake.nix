{
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    systems.url = "github:nix-systems/default";
  };

  outputs = { self, devenv, nixpkgs, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            nodejs = pkgs.nodejs;
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  name = "legend-of-hotwire";

                  languages.javascript = {
                    enable = true;
                    package = nodejs;
                  };

                  languages.ruby = {
                    enable = true;
                    versionFile = ./.ruby-version;
                  };

                  packages = [
                    (pkgs.yarn.override { inherit nodejs; })
                  ];

                  process.implementation = "overmind";
                  processes = {
                    css.exec = "yarn build:css --watch";
                    js.exec = "yarn build --watch=forever";
                    web.exec = "unset PORT && bin/rails server";
                    worker.exec = "bundle exec sidekiq -t 10";
                  };

                  services.postgres.enable = true;
                  services.redis.enable = true;
                }
              ];
            };
          });
    };
}
