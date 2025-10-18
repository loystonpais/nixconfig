# Source: https://github.com/greg-hellings/nixos-config/blob/8119b9e0a52559fa1bc166592828079b757f476e/modules/hm/xonsh.nix#L4
{
  config,
  lib,
  ...
}: let
  cfg = config.programs.xonsh;
in
  with lib; {
    options = {
      programs.xonsh = {
        enable = mkEnableOption "Enable the xonsh program";

        sessionVariables = mkOption {
          type = types.attrs;
          default = {};
          example = {
            XONSH_TRACE_SUBPROC = true;
          };
          description = ''
            Environment variables that will be set for the Xonsh session.
          '';
        };

        aliases = mkOption {
          type = types.attrsOf types.str;
          default = {};
          example = literalExpression ''
            {
            	ll = "ls -l";
            	la = "ls -a";
            }
          '';
          description = ''
            An attribute set that maps aliases (the top level attribute names in
            this option) to command strings or directly to build outputs.
          '';
        };

        configHeader = mkOption {
          type = types.lines;
          default = "";
          example = literalExpression ''
            import os
            import sys
          '';
          description = "An arbitrary string to put at the top of the config file";
        };

        configFooter = mkOption {
          type = types.lines;
          default = "";
          example = literalExpression ''
            def _some_method(args):
            	do_command()
            	some_other_thing()
            aliases['some_method'] = _some_method
          '';
          description = "An arbitrary string to put at the end of the config file";
        };
      };
    };

    config = let
      shortAliases = concatStringsSep "\n" (mapAttrsToList (k: v: "aliases['${k}']=r'${v}'") cfg.aliases);

      listToPythonList = let
        listInternals = args: concatStringsSep "\n" (map (v: "'${v}'") args);
      in
        list: "[${listInternals list}]";

      sessionVars = concatStringsSep "\n" (
        mapAttrsToList (
          k: v:
            if builtins.typeOf v == "string"
            then "\$${k} = '${v}'"
            else if builtins.typeOf v == "list"
            then "\$${k} = ${listToPythonList}"
            else if builtins.typeOf v == "int"
            then "\$${k} = ${toString v}"
            else ""
        )
        cfg.sessionVariables
      );
    in
      mkIf cfg.enable {
        home.file.".xonshrc".text = ''
          ${cfg.configHeader}

          ${sessionVars}

          ${shortAliases}

          ${cfg.configFooter}
        '';
      };
  }
