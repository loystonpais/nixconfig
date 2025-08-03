{config, ...}: {
  virtualisation.kvmfr = {
    enable = true;

    shm = {
      enable = true;

      size = 32;
      user = config.lunar.username;
      group = "kvm";
      mode = "0600";
    };
  };
}
