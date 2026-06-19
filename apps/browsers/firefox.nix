{
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;

    # === 策略配置 ===
    policies = {
      DisablePocket = true;
      DisplayBookmarksToolbar = "always";
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnable = false;
      ShowHomeButton = true;
      NoDefaultBookmarks = lib.mkForce true;

      FirefoxHome = {
        Search = true;
        TopSites = true;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
      };

      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    # === 用户配置 ===
    profiles.davyjones = {
      id = 0;
      isDefault = true;
      name = "davyjones";

      settings = {
        "dom.security.https_only_mode" = false;
        "dom.security.https_first" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.search.separatePrivateDefault" = false;
        "browser.search.separatePrivateDefault.ui.enabled" = true;
        "network.trr.mode" = 5;
        "browser.uidensity" = 0;
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.page" = 1;
      };

      bookmarks = {
        force = true;
        settings = [
          {
            name = "Gemini";
            url = "https://gemini.google.com/";
          }
          {
            name = "Bilibili";
            url = "https://www.bilibili.com/";
          }
          {
            name = "Nix Packages";
            url = "https://search.nixos.org/packages";
          }
          #{
          #  name = "Toolbar";
          #  toolbar = true;
          #  bookmarks = [
          #    {
          #      name = "Gemini";
          #      url = "https://gemini.google.com/";
          #    }
          #    {
          #      name = "Bilibili";
          #      url = "https://www.bilibili.com/";
          #    }
          #    {
          #      name = "Nix Packages";
          #      url = "https://search.nixos.org/packages";
          #    }
          #  ];
          #}
        ];
      };

      # 搜索引擎配置
      search = {
        default = "cnbing";
        force = true;
        engines = {
          "cnbing" = {
            urls = [
              {
                template = "https://bing.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            definedAliases = ["@g"];
          };
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
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
            definedAliases = ["@np"];
          };
          "Home Manager" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com/";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            icon = "https://home-manager-options.extranix.com/images/favicon.png";
            definedAliases = ["@hm"];
          };
          "bing".metaData.hidden = true;
          "google".metaData.hidden = true;
          "amazon".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        bitwarden
        adguard
        pywalfox
        firefox-color
        sponsorblock
      ];
    };
  };
}
