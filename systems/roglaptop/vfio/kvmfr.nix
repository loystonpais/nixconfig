{config, ...}: {
  virtualisation.kvmfr = {
    enable = true;

    shm = {
      enable = true;

      size = 32;
      group = "kvm";
      mode = "0600";
    };
  };
}
