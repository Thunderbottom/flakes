let
  keys = import ../modules/profile/_ssh-keys.nix;
  inherit (keys.users) codingcoffee thunderbottom;
  inherit (keys.machines)
    donkpad
    zippyrus
    smolboye
    bicboye
    ;
  users = thunderbottom ++ codingcoffee;
in
{
  "machines/donkpad/password.age".publicKeys = thunderbottom ++ donkpad;
  "machines/donkpad/root-password.age".publicKeys = thunderbottom ++ donkpad;
  "machines/zippyrus/password.age".publicKeys = thunderbottom ++ zippyrus;
  "machines/zippyrus/root-password.age".publicKeys = thunderbottom ++ zippyrus;
  "machines/bicboye/password.age".publicKeys = thunderbottom ++ bicboye;
  "machines/bicboye/root-password.age".publicKeys = thunderbottom ++ bicboye;
  "machines/smolboye/password.age".publicKeys = thunderbottom ++ smolboye;
  "machines/smolboye/root-password.age".publicKeys = thunderbottom ++ smolboye;
  "monitoring/grafana/password.age".publicKeys = thunderbottom ++ bicboye;
  "network-manager/passphrase.age".publicKeys = thunderbottom ++ zippyrus;
  "services/backups/environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/backups/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/bluesky-pds/environment.age".publicKeys = thunderbottom ++ bicboye;
  "services/bluesky-pds/ssl-email.age".publicKeys = thunderbottom ++ bicboye ++ smolboye;
  "services/bluesky-pds/ssl-api-key.age".publicKeys = thunderbottom ++ bicboye ++ smolboye;
  "services/cloudflare-ddns/api-token.age".publicKeys = thunderbottom ++ bicboye;
  "services/forgejo/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/forgejo/actions-runner/token.age".publicKeys = thunderbottom ++ bicboye;
  "services/harmonia/signing-key.age".publicKeys = thunderbottom ++ bicboye;
  "services/mailserver/watashi.age".publicKeys = thunderbottom ++ smolboye;
  "services/mailserver/noreply.age".publicKeys = thunderbottom ++ smolboye;
  "services/miniflux/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/paperless/password.age".publicKeys = users ++ bicboye;
  "services/qui/session-secret.age".publicKeys = thunderbottom ++ bicboye;
  "services/unifi-unpoller/password.age".publicKeys = users ++ bicboye;
  "services/vaultwarden/password.age".publicKeys = users ++ bicboye ++ smolboye;
}
