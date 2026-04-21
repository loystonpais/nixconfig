{
  den,
  lunar,
  lib,
  ...
}: {
  den.aspects.loystonpais = {
    includes = [
      den.provides.primary-user
      (den.provides.user-shell "zsh")
      den.provides.define-user
    ];

    nixos = {
      pkgs,
      config,
      ...
    }: {
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
        initialPassword = "loystonpais";
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
        ruby
        unar
        nil
        lsd
        tldr
        broot
        compsize
        alejandra
        jq
        rsync
        gh
        pass
        jq
        yq-go
        fzf
        bat
        yt-dlp
        fd

        python3Packages.markitdown
      ];

      nix = {
        settings = {
          trusted-users = ["loystonpais"];
        };
      };

      security.acme = {
        defaults.email = "loyston500@gmail.com";
      };

      home-manager = {
        backupFileExtension = "nixbak";
        useGlobalPkgs = true;
        useUserPackages = true;
      };

      networking.networkmanager.enable = true;

      virtualisation.vmVariant.networking.hostName = lib.mkForce "${config.networking.hostName}-vm";

      programs.nix-ld.enable = true;
    };

    homeManager = {pkgs, ...}: {
      home = {
        packages = with pkgs; [
          htop
        ];
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

      home.stateVersion = lib.mkDefault "25.11";
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
        (lunar.plasma)
        lunar.niri
        lunar.dms
        lunar.browsers
        lunar.fonts
        lunar.graphics
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
        lunar.git
        lunar.hardware
        lunar.tailscale
        lunar.android
        lunar.devenv
      ];
    };

    provides.nixacle = {
      includes = [
        lunar.determinate
        lunar.tailscale
        lunar.ssh
        lunar.git
        lunar.dev
        lunar.sops

        lunar.server
        lunar.server._.linux-kernel-618-temp-boot-fix
        lunar.server._.oracle-alwaysfree-e2-instance
        lunar.server._.share-host-secrets
        lunar.server._.storage-management
        lunar.server._.vm-enhancements
        lunar.server._.no-ipv6

        lunar.acme
        (lunar.acme._.freedns-afraid {domainName = "loy.ftp.sh";})

        # TODO: Remove this later when the dep with lunar.dev is removed
        lunar.xonsh
      ];
    };

    provides.diviner = {
      includes = [
        lunar.determinate
        lunar.tailscale
        lunar.ssh
        lunar.git
        lunar.dev
        lunar.sops

        lunar.server
        lunar.server._.linux-kernel-618-temp-boot-fix
        lunar.server._.oracle-alwaysfree-e2-instance
        lunar.server._.share-host-secrets
        lunar.server._.storage-management
        lunar.server._.vm-enhancements
        lunar.server._.no-ipv6

        # TODO: Remove this later when the dep with lunar.dev is removed
        lunar.xonsh
      ];
    };
  };
}
