{
  flake.modules.nixos.nginx =
    {
      config,
      lib,
      ...
    }:
    {
      config = {

        security.acme.defaults.email = config.profile.email;
        networking.firewall.allowedTCPPorts = [
          80
          443
        ];
        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedOptimisation = true;
          recommendedGzipSettings = true;
          recommendedTlsSettings = true;

          # Disable default_server access and return HTTP 444.
          appendHttpConfig = ''
            # Strict Transport Security (HSTS): Yes
            add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";

            # Minimize information leaked to other domains
            add_header 'Referrer-Policy' 'strict-origin-when-cross-origin';

            # Disable embedding as a frame
            # add_header X-Frame-Options SAMEORIGIN;

            # Prevent injection of code in other mime types (XSS Attacks)
            add_header X-Content-Type-Options nosniff;

            server {
              listen 80 http2 default_server;
              listen 443 ssl http2 default_server;

              ssl_reject_handshake on;
              return 444;
            }
          ''
          + ''
            ${lib.concatMapStrings (ip: "set_real_ip_from ${ip};\n") (
              lib.filter (line: line != "") (
                lib.splitString "\n" ''
                  ${lib.readFile (
                    builtins.fetchurl {
                      url = "https://www.cloudflare.com/ips-v4/";
                      sha256 = "sha256-8Cxtg7wBqwroV3Fg4DbXAMdFU1m84FTfiE5dfZ5Onns=";
                    }
                  )}
                  ${lib.readFile (
                    builtins.fetchurl {
                      url = "https://www.cloudflare.com/ips-v6/";
                      sha256 = "sha256-np054+g7rQDE3sr9U8Y/piAp89ldto3pN9K+KCNMoKk=";
                    }
                  )}
                ''
              )
            )}
            real_ip_header CF-Connecting-IP;
          '';
        };
      };
    };
}
