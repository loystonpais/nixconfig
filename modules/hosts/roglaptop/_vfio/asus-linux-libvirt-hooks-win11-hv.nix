{
  config,
  pkgs,
  lib,
  ...
}: {
  config = let
    domain-name = "win11-hv";
  in {
    virtualisation.libvirtd.hooks.qemu."hook-win11-hv" = let
      vmVarsConf = pkgs.writeShellScript "vm-vars.conf" ''
        export PATH="$PATH:${lib.makeBinPath [
          pkgs.supergfxctl
          pkgs.power-profiles-daemon
          pkgs.busybox
          pkgs.systemd
        ]}"
        ## Win11 HV Boot Script Parameters

        # How much memory we've assigned to the VM, in kibibytes
        VM_MEMORY=15085836 #* Assign Max Ram - 512 mb

        # Set the governor to use when the VM is on, and which
        # one we should return to once the VM is shut down
        VM_ON_GOVERNOR=performance
        VM_OFF_GOVERNOR=performance

        # Set the powerprofiles ctl profile to performance when
        # the VM is on, and power-saver when the VM is shut down
        VM_ON_PWRPROFILE=performance
        VM_OFF_PWRPROFILE=performance

        # Set which CPU's to isolate, and your system's total
        # CPU's. For example, an 8-core, 16-thread processor has
        # 16 CPU's to the system, numbered 0-15. For a 6-core,
        # 12-thread processor, 0-11. The SYS_TOTAL_CPUS variable
        # should always reflect this.
        #
        # You can define these as a range, a list, or both. I've
        # included some examples:
        #
        # EXAMPLE=0-3,8-11
        # EXAMPLE=0,4,8,12
        # EXAMPLE=0-3,8,11,12-15
        HOST_ALLOWED_CPUS=0-1 #* Assign 2-15 to VM
        SYS_TOTAL_CPUS=0-15
      '';

      hooksDir = pkgs.linkFarm "qemu-hooks-dir" {
        "${domain-name}/prepare/begin/30-set-governor.sh" = pkgs.writeShellScript "30-set-governor.sh" ''
          source "${vmVarsConf}"


          ## Set CPU governor to mode indicated by variable
          CPU_COUNT=0
          for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
          do
              echo $VM_ON_GOVERNOR > $file;
              echo "CPU $CPU_COUNT governor: $VM_ON_GOVERNOR";
              let CPU_COUNT+=1
          done

          ## Set system power profile to performance
          powerprofilesctl set $VM_ON_PWRPROFILE

          sleep 1
        '';

        #* Just shutdown at end
        "${domain-name}/release/end/20-shutdown.sh" = pkgs.writeShellScript "20-shutdown.sh" ''
          source "${vmVarsConf}"

          echo "Shutting HV down.."
          # shutdown now

          sleep 1
        '';
      };
    in
      pkgs.writeShellScript "qemu-nix" ''
        GUEST_NAME="$1"
        HOOK_NAME="$2"
        STATE_NAME="$3"
        MISC="''${@:4}"

        echo "$(date): Script triggered for VM $1, action $2, phase $3" >> /tmp/qemu-hook.log

        HOOKPATH="${hooksDir}/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

        set -e # If a script exits with an error, we should as well.

        # check if it's a non-empty executable file
        if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH" ] && [ -x "$HOOKPATH" ]; then
            echo "Executing hook: $HOOKPATH"
            eval \"$HOOKPATH\" "$@"
        elif [ -d "$HOOKPATH" ]; then
            while read file; do
                # check for null string
                if [ ! -z "$file" ]; then
                  eval \"$file\" "$@"
                fi
            done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"
        fi
      '';
  };
}
