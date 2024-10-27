{
  description = "Nipun's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      macConfiguration =
        { pkgs, config, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = with pkgs; [
            tmux
            pam-reattach
            oh-my-zsh
            fzf
            neovim
            vim
            # stow
            mkalias
            nil
            nixfmt-rfc-style
            # lolcat
            # mycli
            # ripgrep
            # fd
            # colorls
            # zoxide
          ];

          homebrew = {
            enable = true;

            casks = [
              # "kitty"
              # "google-chrome"
              "keka"
              # "jetbrains-toolbox"
              # "tailscale"
            ];

            brews = [
              "mas"
              "imagemagick"
              # "starship"
              # "httpd"
              # "php"
              # "mysql"
              # "btop"
            ];

            masApps = {
              # "Pages" = 409201541;
            };

            # onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          fonts.packages = [
            pkgs.inter
            (pkgs.nerdfonts.override {
              fonts = [
                "JetBrainsMono"
                "NerdFontsSymbolsOnly"
              ];
            })
          ];

          # Convert symlinks to macOS aliases for apps (symlinks won't be indexed by spotlight)
          system.activationScripts.applications.text =
            let
              env = pkgs.buildEnv {
                name = "system-applications";
                paths = config.environment.systemPackages;
                pathsToLink = "/Applications";
              };
            in
            pkgs.lib.mkForce ''
              # Set up applications.
              echo "setting up /Applications..." >&2
              rm -rf /Applications/Nix\ Apps
              mkdir -p /Applications/Nix\ Apps
              find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
              while read src; do
                app_name=$(basename "$src")
                echo "copying $src" >&2
                ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
              done
            '';

          # security.pam.enableSudoTouchIdAuth = true; # this will make changes to /etc/pam.d/sudo which gets reset on system updates

          # enable touchId for sudo (this will add pam_tid.so to /etc/pam.d/sudo_local which is not affected by system updates)
          environment = {
            etc."pam.d/sudo_local".text = ''
              # Managed by Nix Darwin
              auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
              auth       sufficient     pam_tid.so
            '';

            etc."zshenv.local".text = ''
              # Set zsh config directory
              export ZDOTDIR=$HOME/.config/zsh
            '';
          };

          # Home Manager configuration.
          users.users.nipun = {
            name = "nipun";
            home = "/Users/nipun";
          };
          home-manager.backupFileExtension = "backup";
          nix.configureBuildUsers = true;
          nix.useDaemon = true;

          # Set up system settings.
          system.defaults = {
            dock = {
              autohide = true;
              show-recents = false;
              mru-spaces = false;

              # persistent-apps = [
              #   "/Applications/Launchpad.app"
              #   "/Applications/kitty.app"
              #   "/Applications/Safari.app"
              #   "/Applications/Mail.app"
              #   "/Applications/Keka.app"
              # ];
            };

            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
              ShowStatusBar = true;
            };

            trackpad = {
              Clicking = true;
              ActuationStrength = 0;
              FirstClickThreshold = 0;
              SecondClickThreshold = 1;
              TrackpadRightClick = true;
              TrackpadThreeFingerDrag = true;
            };

            WindowManager = {
              AutoHide = true;
              StandardHideWidgets = false;
              StageManagerHideWidgets = true;
              EnableStandardClickToShowDesktop = true;
              AppWindowGroupingBehavior = true;
            };

            spaces = {
              spans-displays = false;
            };

            ".GlobalPreferences"."com.apple.mouse.scaling" = -1.0; # -1.0 means no acceleration

            loginwindow.GuestEnabled = false;

            NSGlobalDomain.AppleICUForce24HourTime = true;
            # NSGlobalDomain.KeyRepeat = 2;
          };

          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          # Create /etc/zshrc that loads the nix-darwin environment.
          programs.zsh.enable = true; # default shell on catalina
          # programs.fish.enable = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#simple
      darwinConfigurations."air" = nix-darwin.lib.darwinSystem {
        modules = [
          macConfiguration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nipun = import ./home.nix;
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."air".pkgs;
    };
}
