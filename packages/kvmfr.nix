{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel ? pkgs.linuxPackages.kernel,
  kmod,
  looking-glass-client,
  pkgs,
  ...
}:
stdenv.mkDerivation rec {
  pname = "kvmfr-${version}-${kernel.version}";
  version = looking-glass-client.version;

  src = looking-glass-client.src;
  sourceRoot = "source/module";
  hardeningDisable = ["pic" "format"];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    install -D kvmfr.ko -t "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/"
  '';

  meta = with lib; {
    description = "This kernel module implements a basic interface to the IVSHMEM device for LookingGlass";
    homepage = "https://github.com/gnif/LookingGlass";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [j-brn];
    platforms = ["x86_64-linux"];
  };
}
