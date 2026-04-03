{
  den,
  lunar,
  ...
}: {
  den.aspects.loystonpais = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "zsh")
      den.provides.define-user
    ];

    nixos = {pkgs, ...}: {
      time.timeZone = "Asia/Kolkata";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = [
          "en_US.UTF-8/UTF-8"
          "en_GB.UTF-8/UTF-8"
          "en_IN/UTF-8"
        ];
      };

      users.users.loystonpais = {
        extraGroups = ["networkmanager" "wheel" "disk" "i2c"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
        ];
      };

      environment.systemPackages = with pkgs; [
        micro
        git
        fastfetch
        nh
        pciutils
        ripgrep
        file
        busybox
        python3
        unar
        nil
        lsd
        tldr
        broot
        compsize
        alejandra
        ruby
        jq
        rsync
      ];

      nix = {
        settings = {
          trusted-users = ["loystonpais"];
        };
      };

      home-manager = {
        backupFileExtension = "nixbak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      networking.networkmanager.enable = true;
    };

    homeManager = {pkgs, ...}: {
      home = {
        packages = with pkgs; [
          htop
        ];

        stateVersion = "25.11";
      };

      programs.git = {
        enable = true;
        settings = {
          user.name = "loystonpais";
          user.email = "loyston500@gmail.com";
          alias = {
            pu = "push";
            ch = "checkout";
            cm = "commit";
          };
        };
      };
    };

    provides.substituters = {
      nixos.nix.settings = {
        substituters = [
          "https://loystonpais.cachix.org?priority=10"
        ];
        trusted-public-keys = [
          "loystonpais.cachix.org-1:lclfaBitH51Lw9WwBxQ4bbesdt7c01JlFbKoSZ0PMLc="
        ];
      };
    };

    provides.roglaptop = {
      includes = [
        lunar.determinate
        lunar.audio
        lunar.cuda
        lunar.distrobox
        lunar.podman
        lunar.misc
        (lunar.plasma "mac")
        lunar.niri
        lunar.dms
        lunar.browsers
        lunar.fonts
        lunar.graphics
        lunar.hardware
        lunar.gaming
        (lunar.gamedev {cudaTools = true;})
        lunar.minecraft
        lunar.multimedia
        lunar.piracy
        lunar.kitty
        lunar.dev
        lunar.virt
        lunar.virt._.kvmfr
        lunar.virt._.evdev
        lunar.sops
        lunar.hm-home-symlinks
        lunar.asuslinux
        lunar.xonsh
        lunar.ssh
        lunar.vscode
        lunar.dev
        lunar.git
        lunar.hardware
        lunar.tailscale
      ];
    };
  };
}
