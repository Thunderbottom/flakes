{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.nixos-mailserver.nixosModules.mailserver ];

  options.snowflake.services.mailserver = {
    enable = lib.mkEnableOption "Enable mailserver service";

    fqdn = lib.mkOption {
      type = lib.types.str;
      description = "FQDN for the mailserver";
    };

    domains = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Configuration domains to use for the mailserver";
    };

    loginAccounts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hashedPasswordFile = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Path to file containing the hashed password";
            };
            aliases = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of aliases for this account";
            };
            catchAll = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              description = "List of domains for which this account should catch all emails";
            };
            sendOnly = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether this account can only send emails";
            };
          };
        }
      );
      default = { };
      description = "Login accounts for the domain. Every account is mapped to a unix user";
    };
  };

  config =
    let
      cfg = config.snowflake.services.mailserver;
    in
    lib.mkIf cfg.enable {
      # Ref: https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/issues/275
      services.dovecot2.sieve.extensions = [ "fileinto" ];

      mailserver = {
        inherit (cfg)
          enable
          fqdn
          domains
          loginAccounts
          ;

        # Set the state version for nixos-mailserver
        stateVersion = 4;

        # Spin up a stripped-down nginx instance on
        # port 80 to generate a certificate automatically.
        certificateScheme = "acme-nginx";

        # Enable a better way of storing emails.
        useFsLayout = true;

        mailboxes = {
          Archive = {
            auto = "subscribe";
            specialUse = "Archive";
          };
          Drafts = {
            auto = "subscribe";
            specialUse = "Drafts";
          };
          Sent = {
            auto = "subscribe";
            specialUse = "Sent";
          };
          Junk = {
            auto = "subscribe";
            specialUse = "Junk";
          };
          Trash = {
            auto = "subscribe";
            specialUse = "Trash";
          };
        };
      };

      # Prefer using ipv4 and use correct ipv6 address
      # to avoid rDNS issues
      # NOTE: this needs to be changed on every new system.
      # TODO: figure out how to handle this case better.
      services.postfix.extraConfig = ''
        smtp_bind_address6 = 2a01:4f8:1c1c:90b::
        smtp_address_preference = ipv4
      '';

      services.fail2ban.jails = {
        postfix = {
          settings = {
            enabled = true;
            mode = "extra";
          };
        };

        dovecot = {
          settings = {
            enabled = true;
            filter = "dovecot[mode=aggressive]";
            maxretry = 3;
          };
        };
      };
    };
}
