{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    virtualisation.libvirtd.hooks.qemu."qemu-nix" = let
      vmVarsConf = pkgs.writeShellScript "vm-vars.conf" ''
        export PATH="$PATH:${lib.makeBinPath [
          pkgs.supergfxctl
          pkgs.power-profiles-daemon
          pkgs.busybox
          pkgs.systemd
        ]}"
        ## Win10 VM Script Parameters

        # How much memory we've assigned to the VM, in kibibytes
        VM_MEMORY=8388608

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
        VM_ISOLATED_CPUS=0-7
        SYS_TOTAL_CPUS=0-15
      '';

      hooksDir = pkgs.linkFarm "qemu-hooks-dir" [
        {
          name = "win11/prepare/begin/10-asusd-vfio.sh";
          path = pkgs.writeShellScript "10-asusd-vfio.sh" ''
            source "${vmVarsConf}"

            supergfxctl -m Vfio

            echo "Graphics mode set!"
            sleep 1
          '';
        }

        {
          name = "win11/prepare/begin/20-reserve-hugepages.sh";
          path = pkgs.writeShellScript "20-reserve-hugepages.sh" ''
            source "${vmVarsConf}"

            HUGEPAGES="$(($VM_MEMORY/$(($(grep Hugepagesize /proc/meminfo | awk '{print $2}')))))"

            echo "Allocating hugepages at 2048 KiB per page..."
            echo $HUGEPAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

            ## If successful, notify user
            if [ "$ALLOC_PAGES" -eq "$HUGEPAGES" ]
            then
                echo "Successfully allocated $ALLOC_PAGES / $HUGEPAGES pages!"
            fi

            ## Drop caches to free up memory for hugepages if not successful
            if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
            then
                echo 3 > /proc/sys/vm/drop_caches
            fi

            TRIES=0
            while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
            do
                ## Defrag RAM then try to allocate pages again
                echo 1 > /proc/sys/vm/compact_memory
                echo $HUGEPAGES > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
                ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
                ## If successful, notify user
                echo "Successfully allocated $ALLOC_PAGES / $HUGEPAGES pages!"
                let TRIES+=1
            done

            if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
            then
                echo "Not able to allocate all hugepages. Reverting..."
                echo 0 > /proc/sys/vm/nr_hugepages
                exit 1
            fi

            sleep 1
          '';
        }

        {
          name = "win11/prepare/begin/30-set-governor.sh";
          path = pkgs.writeShellScript "30-set-governor.sh" ''
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
        }

        {
          name = "win11/prepare/begin/40-isolate-cpus.sh";
          path = pkgs.writeShellScript "40-isolate-cpus.sh" ''
            source "${vmVarsConf}"

            ## Isolate CPU cores as per set variable
            systemctl set-property --runtime -- user.slice AllowedCPUs=$VM_ISOLATED_CPUS
            systemctl set-property --runtime -- system.slice AllowedCPUs=$VM_ISOLATED_CPUS
            systemctl set-property --runtime -- init.scope AllowedCPUs=$VM_ISOLATED_CPUS

            sleep 1
          '';
        }

        {
          name = "win11/release/end/10-release-hugepages.sh";
          path = pkgs.writeShellScript "10-release-hugepages.sh" ''
            source "${vmVarsConf}"

            ## Remove Hugepages
            echo "Releasing hugepage memory back to the host..."
            echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

            ## Advise if successful
            ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

            if [ "$ALLOC_PAGES" -eq 0 ]
            then
                echo "Memory successfully released!"
            fi

            sleep 1

          '';
        }

        {
          name = "win11/release/end/20-return-cpus.sh";
          path = pkgs.writeShellScript "20-return-cpus.sh" ''
            source "${vmVarsConf}"

            ## Return CPU cores as per set variable
            systemctl set-property --runtime -- user.slice AllowedCPUs=$SYS_TOTAL_CPUS
            systemctl set-property --runtime -- system.slice AllowedCPUs=$SYS_TOTAL_CPUS
            systemctl set-property --runtime -- init.scope AllowedCPUs=$SYS_TOTAL_CPUS

            sleep 1
          '';
        }

        {
          name = "win11/release/end/30-restore-governor.sh";
          path = pkgs.writeShellScript "30-restore-governor.sh" ''
            source "${vmVarsConf}"

            ## Restore CPU governor to mode indicated by variable
            CPU_COUNT=0
            for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
            do
                echo $VM_OFF_GOVERNOR > $file;
                echo "CPU $CPU_COUNT governor: $VM_OFF_GOVERNOR";
                let CPU_COUNT+=1
            done

            ## Restore system power profile to default
            powerprofilesctl set $VM_OFF_PWRPROFILE

            sleep 1
          '';
        }
      ];
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
