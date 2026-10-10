{
  inputs,
  generic,
  nixos,
  ...
}:
{
  flake.modules.nixos.base =
    { config, lib, ... }:
    {
      imports = [
        inputs.agenix.nixosModules.age
        generic.profile
        nixos.core
        nixos.user
      ];

      assertions =
        let
          entries = lib.attrValues config.profile.services;
          duplicates =
            values:
            lib.attrNames (
              lib.filterAttrs (_: n: n > 1) (
                lib.foldl' (acc: v: acc // { ${toString v} = (acc.${toString v} or 0) + 1; }) { } values
              )
            );
          ports = lib.concatMap (
            s:
            lib.filter (v: v != null) [
              (s.port or null)
              (s.torrentPort or null)
              (s.sshPort or null)
            ]
          ) entries;
          domains = lib.concatMap (
            s:
            lib.filter (v: v != null) [
              (s.domain or null)
              (s.sshDomain or null)
            ]
          ) entries;
        in
        [
          {
            assertion = duplicates ports == [ ];
            message = "Duplicate ports in profile.services: ${toString (duplicates ports)}";
          }
          {
            assertion = duplicates domains == [ ];
            message = "Duplicate domains in profile.services: ${toString (duplicates domains)}";
          }
        ];

      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ inputs.self.overlays.default ];
      };
    };
}
