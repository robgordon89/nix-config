{ ... }:
{
  flake.modules.homeManager.k9s = { ... }: {
    programs.k9s = {
      enable = true;

      aliases = {
        aliases = {
          dp = "deployments";
          sec = "v1/secrets";
          jo = "jobs";
          cr = "clusterroles";
          crb = "clusterrolebindings";
          ro = "roles";
          rb = "rolebindings";
          np = "networkpolicies";
        };
      };

      settings = {
        k9s = {
          liveViewAutoRefresh = false;
          refreshRate = 2;
          maxConnRetry = 5;
          readOnly = false;
          noExitOnCtrlC = false;
          ui = {
            enableMouse = false;
            headless = false;
            logoless = true;
            crumbsless = false;
            reactive = false;
            noIcons = false;
          };
          skipLatestRevCheck = false;
          disablePodCounting = false;
          shellPod = {
            image = "busybox";
            namespace = "default";
            limits = {
              cpu = "100m";
              memory = "100Mi";
            };
          };
          imageScans = {
            enable = false;
            exclusions = {
              namespaces = [ ];
              labels = { };
            };
          };
          logger = {
            tail = 100;
            buffer = 5000;
            sinceSeconds = -1;
            fullScreen = false;
            textWrap = false;
            showTime = false;
          };
          thresholds = {
            cpu = {
              critical = 90;
              warn = 70;
            };
            memory = {
              critical = 90;
              warn = 70;
            };
          };
        };
      };

      skins = {
        dark = {
          k9s = {
            body = {
              fgColor = "#eeeeee";
              bgColor = "#000000";
              logoColor = "#2aa198";
            };
            prompt = {
              fgColor = "#eeeeee";
              bgColor = "#000000";
              suggestColor = "#cb4a16";
            };
            info = {
              fgColor = "#d33582";
              sectionColor = "#eeeeee";
            };
            dialog = {
              fgColor = "#eeeeee";
              bgColor = "#000000";
              buttonFgColor = "#eeeeee";
              buttonBgColor = "#d33582";
              buttonFocusFgColor = "#ffffff";
              buttonFocusBgColor = "#2aa197";
              labelFgColor = "#ffb86c";
              fieldFgColor = "#f8f8f2";
            };
            frame = {
              border = {
                fgColor = "#003440";
                focusColor = "#003440";
              };
              menu = {
                fgColor = "#eeeeee";
                keyColor = "#d33582";
                numKeyColor = "#d33582";
              };
              crumbs = {
                fgColor = "#eeeeee";
                bgColor = "#003440";
                activeColor = "#003440";
              };
              status = {
                newColor = "#2aa197";
                modifyColor = "#2aa198";
                addColor = "#859901";
                errorColor = "#dc312e";
                highlightColor = "#cb4a16";
                killColor = "#6272a4";
                completedColor = "#6272a4";
              };
              title = {
                fgColor = "#eeeeee";
                bgColor = "#003440";
                highlightColor = "#cb4a16";
                counterColor = "#2aa198";
                filterColor = "#d33582";
              };
            };
            views = {
              charts = {
                bgColor = "default";
              };
              table = {
                fgColor = "#f8f8f2";
                bgColor = "default";
                header = {
                  fgColor = "#f8f8f2";
                  bgColor = "default";
                  sorterColor = "#8be9fd";
                };
              };
              xray = {
                fgColor = "#f8f8f2";
                bgColor = "default";
                cursorColor = "#44475a";
                graphicColor = "#bd93f9";
                showIcons = false;
              };
              yaml = {
                keyColor = "#ff79c6";
                colonColor = "#bd93f9";
                valueColor = "#f8f8f2";
              };
              logs = {
                fgColor = "#f8f8f2";
                bgColor = "default";
                indicator = {
                  fgColor = "#f8f8f2";
                  bgColor = "default";
                  toggleOnColor = "#50fa7b";
                  toggleOffColor = "#8be9fd";
                };
              };
            };
          };
        };
      };
    };
  };
}
