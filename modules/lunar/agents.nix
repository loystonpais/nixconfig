{
  den,
  lib,
  ...
}: let
  globalPromptFiles = {
    opencode = ".config/opencode/AGENTS.md";
    gemini-cli = ".gemini/GEMINI.md";
  };

  addTextToFileInHome = file: text: {
    homeManager.home.file.${file}.text = text;
  };

  addTextToFilesInHome = files: text: lib.mkMerge (map (f: addTextToFileInHome f text) files);

  addTextToAllGlobalPromptFiles = addTextToFilesInHome (lib.attrValues globalPromptFiles);

  mkIsolatedAgentBin = {
    homeDir,
    binName,
    agent,
    bubblewrap,
    writeShellScriptBin,
  }:
    writeShellScriptBin binName ''
      mkdir -p "${homeDir}"
      exec ${lib.getExe bubblewrap} \
        --ro-bind /usr /usr \
        --ro-bind /nix /nix \
        --ro-bind /bin /bin \
        --ro-bind /etc /etc \
        --ro-bind /run/current-system/sw/bin /run/current-system/sw/bin \
        --ro-bind "$HOME" "$HOME" \
        --bind /tmp /tmp \
        --bind "$HOME/${homeDir}" "$HOME/${homeDir}" \
        --bind "$(pwd)" "$(pwd)" \
        --tmpfs "$XDG_RUNTIME_DIR" \
        --setenv HOME            "$HOME/${homeDir}" \
        --setenv XDG_CONFIG_HOME "$HOME/${homeDir}/.config" \
        --setenv XDG_DATA_HOME   "$HOME/${homeDir}/.local/share" \
        --setenv XDG_CACHE_HOME  "$HOME/${homeDir}/.cache" \
        --setenv XDG_STATE_HOME  "$HOME/${homeDir}/.local/state" \
        --proc /proc \
        --dev /dev \
        ${lib.getExe agent} "$@"
    '';
in {
  lunar.agents = {
    provides.prompt-notify-via-zenity = lib.mkMerge [
      {
        homeManager = {pkgs, ...}: {
          home.packages = with pkgs; [zenity];
        };
      }

      (addTextToAllGlobalPromptFiles ''
        # Task Completion Notifications

        After completing every task, notify the user using `zenity`. Run the following command in the terminal as the final step:

        ```bash
        zenity --notification --text="<short summary of what was completed>"
        ```

        Examples:
        ```bash
        zenity --notification --text="Build complete"
        zenity --notification --text="Files refactored successfully"
        zenity --notification --text="Tests passed"
        zenity --notification --text="Dependency installation done"
        ```

        Keep the message short and specific to what was just done. Always run this as the last step, after all other work is finished.

      '')
    ];

    provides.isolated-agents = {
      agents,
      usernames,
      ...
    }:
      lib.mkMerge [
        {
          homeManager.home.file."Agents/.directory".text = ''
            Agents Directory
          '';
        }

        (lib.flatten (map (
            agent:
              map (
                username: {
                  homeManager = {
                    pkgs,
                    lib,
                    ...
                  }: let
                    agentHome = "Agents/home/${username}";
                  in
                    lib.mkMerge [
                      {
                        home.packages = [
                          (mkIsolatedAgentBin {
                            homeDir = agentHome;
                            binName = "${agent.meta.mainProgram}-${username}";
                            inherit (pkgs) bubblewrap writeShellScriptBin;
                          })
                        ];
                      }
                    ];
                }
              )
              usernames
          )
          agents))
      ];
  };
}
