{ pkgs, inputs }:
{
  force = true;
  default = "kagi";
  order = [
    "kagi"
    "nix-pkgs"
    "nix-options"
    "nix-wiki"
    "noogle"
  ];
  engines = {
    "nix-pkgs" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };
    "nix-options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = [
            {
              name = "channel";
              value = "unstable";
            }
            {
              name = "type";
              value = "packages";
            }
            {
              name = "query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@no" ];
    };
    "nix-wiki" = {
      urls = [
        {
          template = "https://wiki.nixos.org/index.php";
          params = [
            {
              name = "search";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [
        "@nixoswiki"
        "@nw"
      ];
    };
    "noogle" = {
      urls = [
        {
          template = "https://noogle.dev/q";
          params = [
            {
              name = "term";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [
        "@noogle"
        "@ng"
      ];
    };
    "kagi" = {
      urls = [
        {
          template = "https://kagi.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
        }
        {
          template = "https://kagi.com/api/autosuggest";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
          ];
          type = "application/x-suggestions+json";
        }
      ];
      icon = "https://kagi.com/favicon.ico";
      definedAliases = [
        "@kagi"
        "@k"
      ];
    };
    wikipedia.metaData.alias = "@wiki";
    ebay-nl.metaData.hidden = true;
    ecosia.metaData.hidden = true;
    google.metaData.hidden = true;
    qwant.metaData.hidden = true;
    bing.metaData.hidden = true;
    ddg.metaData.hidden = true;
  };
}
