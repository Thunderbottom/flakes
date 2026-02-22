let
  data = import ../data.nix;
  inherit (data.sshKeys.users) codingcoffee thunderbottom;
  inherit (data.sshKeys.machines) donkpad thonkpad zippyrus smolboye bicboye;

  servers = bicboye ++ smolboye;
  users = thunderbottom ++ codingcoffee;
in
{
  "machines/donkpad/password.age".publicKeys = thunderbottom ++ donkpad;
  "machines/donkpad/root-password.age".publicKeys = thunderbottom ++ donkpad;
  "machines/thonkpad/password.age".publicKeys = thunderbottom ++ thonkpad;
  "machines/thonkpad/root-password.age".publicKeys = thunderbottom ++ thonkpad;
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
  "services/bluesky-pds/ssl-environment.age".publicKeys = thunderbottom ++ bicboye ++ smolboye;
  "services/forgejo/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/forgejo/actions-runner/token.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/maddy/user-watashi.age".publicKeys = thunderbottom ++ servers;
  "services/mailserver/watashi.age".publicKeys = thunderbottom ++ smolboye;
  "services/mailserver/noreply.age".publicKeys = thunderbottom ++ smolboye;
  "services/miniflux/password.age".publicKeys = thunderbottom ++ bicboye;
  "services/paperless/password.age".publicKeys = users ++ bicboye;
  "services/unifi-unpoller/password.age".publicKeys = users ++ bicboye;
  "services/vaultwarden/password.age".publicKeys = users ++ bicboye ++ smolboye;
}
