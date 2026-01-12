{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    hardware.nvidia.prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      amdgpuBusId = "PCI:06:00:0";
      nvidiaBusId = "PCI:01:00:0";
    };

    networking.dhcpcd.extraConfig = ''
      interface wlo1
      metric 99

      interface enp4s0
      metric 98
    '';

    networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
    networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
    #! networking.interfaces.enp6s0f4u1.useDHCP = lib.mkDefault true; # USB Tethering

    hardware.i2c.enable = true;

    services.pipewire.extraConfig.pipewire."80-combined" = {
      "context.modules" = [
        {
          name = "libpipewire-module-combine-stream";
          args = {
            "combine.mode" = "sink";
            "node.name" = "systemoutput+hdmioutput";
            "node.description" = "Both Laptop speakers and HDMI/Monitor speakers (systemoutput+hdmioutput)";
            "node.nick" = "systemoutput+hdmioutput";
            "combine.latency-compensate" = true;

            "combine.volume-sync" = true;
            "node.autoconnect" = true;

            "combine.props" = {
              "audio.position" = ["FL" "FR"];
            };
            "stream.rules" = [
              {
                matches = [
                  {
                    # "media.class" = "Audio/Sink";
                    "node.name" = "alsa_output.pci-0000_06_00.6.analog-stereo";
                  }
                ];
                actions = {
                  create-stream = {
                    "combine.audio.position" = ["FL" "FR"];
                    "audio.position" = ["FL" "FR"];
                  };
                };
              }

              {
                matches = [
                  {
                    # "media.class" = "Audio/Sink";
                    "node.name" = "alsa_output.pci-0000_01_00.1.hdmi-stereo";
                  }
                ];
                actions = {
                  create-stream = {
                    "combine.audio.position" = ["FL" "FR"];
                    "audio.position" = ["FL" "FR"];
                  };
                };
              }
            ];
          };
        }
      ];
    };

    services.pipewire.wireplumber.extraConfig."70-naming" = let
      rule = name: newNick: newDescription: {
        matches = [{"node.name" = name;}];
        actions = {
          update-props = {
            "node.nick" = newNick;
            "node.description" = newDescription;
          };
        };
      };
    in {
      "monitor.alsa.rules" = [
        (rule
          "alsa_output.pci-0000_06_00.6.analog-stereo"
          "systemoutput"
          "Laptop inbuilt speakers (systemoutput)")

        (rule "alsa_output.pci-0000_01_00.1.hdmi-stereo"
          "hdmioutput"
          "HDMI/Monitor Speakers (hdmioutput)")

        # input ones
        (rule
          "alsa_input.pci-0000_06_00.6.analog-stereo"
          "systeminput"
          "Laptop inbuilt microphone (systeminput)")
      ];
    };
  };
}
