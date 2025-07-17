{
  config,
  self,
  options,
  lib,
  ...
}:
{
  options.snowflake.meta = {
    domains = {
      list = lib.mkOption {
        description = "List of all the domains mapped to this host";
        type = lib.types.listOf lib.types.nonEmptyStr;
        default = [ ];
        internal = true;
      };

      globalList = lib.mkOption {
        type = lib.types.listOf lib.types.nonEmptyStr;
        default =
          self.nixosConfigurations
          |> lib.mapAttrsToList (_: value: value.config.snowflake.meta.domains.list)
          |> lib.concatLists;
        internal = true;
        readOnly = true;
      };
    };

    ports = {
      list = lib.mkOption {
        description = "List of all the ports open on this host";
        type = lib.types.listOf lib.types.port;
        default = [ ];
        internal = true;
      };
    };

    ip = {
      v4 = lib.mkOption {
        description = "The host ipv4 address to be used by services";
        type = lib.types.str;
        default = "";
        internal = true;
      };
      v6 = lib.mkOption {
        description = "The host ipv6 address to be used by services";
        type = lib.types.str;
        default = "";
        internal = true;
      };
    };

    assertUnique = lib.mkEnableOption "" // {
      default = true;
    };
  };

  config =
    let
      cfg = config.snowflake.meta;
    in
    lib.mkIf cfg.assertUnique {
      assertions =
        let
          duplicateDomains =
            self.nixosConfigurations
            |> lib.mapAttrsToList (_: value: value.options.snowflake.meta.domains.list.definitionsWithLocations)
            |> lib.concatLists
            |> lib.concatMap (
              entry:
              map (domain: {
                file = entry.file;
                inherit domain;
              }) entry.value
            )
            |> lib.groupBy (entry: toString entry.domain)
            |> lib.filterAttrs (domain: entries: lib.length entries > 1);

          domainError =
            duplicateDomains
            |> lib.mapAttrsToList (
              domain: entries:
              "Duplicate domain \"${domain}\" found in:\n"
              + lib.concatMapStrings (entry: "  - ${entry.file}\n") entries
            )
            |> lib.concatStrings;

          duplicatePorts =
            options.snowflake.meta.ports.list.definitionsWithLocations
            |> lib.concatMap (
              entry:
              map (port: {
                inherit (entry) file;
                inherit port;
              }) entry.value
            )
            |> lib.groupBy (entry: toString entry.port)
            |> lib.filterAttrs (port: entries: lib.length entries > 1);

          portError =
            duplicatePorts
            |> lib.mapAttrsToList (
              port: entries:
              "Duplicate port ${port} found in:\n" + lib.concatMapStrings (entry: "  - ${entry.file}\n") entries
            )
            |> lib.concatStrings;
        in
        [
          {
            assertion = duplicateDomains == { };
            message = domainError;
          }
          {
            assertion = duplicatePorts == { };
            message = portError;
          }
        ];
    };
}
