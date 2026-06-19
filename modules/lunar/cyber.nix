{
  den,
  inputs,
  ...
}: {
  lunar.cyber = {
    host,
    user,
    ...
  }: {
    nixos = {
      config,
      lib,
      inputs',
      pkgs-stable,
      ...
    }: let
      pkgs = pkgs-stable;
      burpsuite = pkgs.burpsuite;

      # Source: https://github.com/Red-Flake/Burpsuite-Professional
      # & https://github.com/xiv3r/Burpsuite-Professional
      burpsuite-pro = let
        pname = "burpsuite-pro";

        # Use java version 21 or else activation won't work

        # This one provides better UI but unfortunately a lot of UI elements
        # like file picker appear broken
        # jdk = pkgs.jetbrains.jdk-no-jcef-21;

        jdk = pkgs.jdk21;

        loader = pkgs.fetchurl {
          url = "https://github.com/xiv3r/Burpsuite-Professional/raw/86b7e0234b7162394fc412921ecc7e14ee07bce8/loader.jar";
          hash = "sha256-3N8orPNgVUpamNePQDyWzOpQC+JLJ9ArAg4UKCBjfAo=";
        };

        javaOpts = [
          "-Dawt.toolkit.name=WLToolkit"
          "-Dsun.java2d.vulkan=True"
          "-Dsun.java2d.accelsd=true"
          "-Duser.name=user"
          "--add-opens=java.desktop/javax.swing=ALL-UNNAMED"
          "--add-opens=java.base/java.lang=ALL-UNNAMED"
          "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED"
          "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED"
          "--add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED"
        ];
      in
        (
          (burpsuite.override {inherit jdk;}).override (
            let
              buildFHSEnv = {...} @ origArgs: let
                src = lib.findFirst (e: lib.hasSuffix "burpsuite.jar" e) null (lib.splitString " " origArgs.runScript);
                runScript = "${lib.getExe jdk} ${lib.concatStringsSep " " javaOpts} -javaagent:${loader} -noverify -jar ${src}";
                targetPkgs = pkgs:
                  (origArgs.targetPkgs pkgs)
                  ++ (with pkgs; [
                    vulkan-loader
                    mesa
                  ]);
                extraInstallCommands = ''
                  ${origArgs.extraInstallCommands}

                  mkdir -p $out/bin
                  ln -s ${pkgs.writeShellScript "burpsuite-loader" ''
                    exec ${lib.getExe jdk} -jar ${loader} "$@"
                  ''} $out/bin/burpsuite-loader

                  chmod -R +w $out/share/applications
                  sed -e 's/^Exec=.*/Exec=${pname}/' \
                    -e 's/^Name=.*/Name=Burp Suite Pro/' \
                    $out/share/applications/burpsuite.desktop \
                    > $out/share/applications/${pname}.desktop
                  rm $out/share/applications/burpsuite.desktop
                '';
                args =
                  origArgs
                  // {
                    inherit pname;
                    inherit runScript;
                    inherit targetPkgs;
                    inherit extraInstallCommands;
                  };
              in
                pkgs.buildFHSEnv args;
            in {
              iconName = "pro";
              inherit buildFHSEnv;
            }
          )
        ).overrideAttrs {mainProgram = pname;};
    in {
      imports = [
        (import "${inputs.nix-security-box}/wireless.nix" {pkgs = pkgs-stable;})
        (import "${inputs.nix-security-box}/information-gathering.nix" {pkgs = pkgs-stable;})
      ];

      environment.systemPackages = let
        pkgs = pkgs-stable;
      in
        with pkgs; [
          nmap
          masscan

          wireshark

          burpsuite
          burpsuite-pro

          dnsutils
          dnsrecon
          dnsmonster

          jadx

          metasploit

          zap

          rustscan

          nikto

          dirbuster
          gobuster

          wordlists
        ];

      environment.etc."lunar/cyber/wordlists".source = "${pkgs.wordlists}/share/wordlists";
      environment.etc."wordlists".source = config.environment.etc."lunar/cyber/wordlists".source;

      environment.etc."lunar/cyber/jython-jar".source = pkgs.jython;
      environment.etc."lunar/cyber/jruby-jar".source = pkgs.jruby;

      programs.wireshark = {
        enable = true;
        dumpcap.enable = true;
        package = pkgs.wireshark-cli;
      };

      users.users.${user.userName} = {
        extraGroups = ["wireshark"];
      };
    };

    homeManager = {pkgs-stable, ...}: let
      pkgs = pkgs-stable;
    in {
      home.file.".lunar/cyber/jython-jar".source = pkgs.jython;
      home.file.".lunar/cyber/jruby-jar".source = pkgs.jruby;
    };
  };
}
