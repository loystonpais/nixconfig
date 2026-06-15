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
    }: {
      imports = [
        (import "${inputs.nix-security-box}/wireless.nix" {pkgs = pkgs-stable;})
        (import "${inputs.nix-security-box}/information-gathering.nix" {pkgs = pkgs-stable;})
      ];

      environment.systemPackages = with pkgs-stable; [
        nmap
        masscan

        wireshark

        burpsuite
      ];

      programs.wireshark = {
        enable = true;
        dumpcap.enable = true;
      };

      users.users.${user.userName} = {
        extraGroups = ["wireshark"];
      };
    };
  };
}
