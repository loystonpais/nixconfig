{
  den,
  inputs,
  ...
}: {
  lunar.cyber = {
    nixos = {
      config,
      lib,
      inputs',
      ...
    }: {
      imports = [
        "${inputs.nix-security-box}/wireless.nix"
      ];

      environment.systemPackages = with inputs'.nixpkgs-stable.legacyPackages; [
        nmap
        masscan
      ];
    };
  };
}
