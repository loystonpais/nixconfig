{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "iso2god-rs";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "iliazeus";
    repo = "iso2god-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rp3ob6Ff41FiYYaDcxDYzo8/0q3Q65FWfAw7tTCWEKc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-1q2ruR2FFtIjBBR4E9Z/icbeVaec2QzWWXbHouJ2+do=";

  meta = {
    description = "A command-line tool to convert Xbox 360 and original Xbox ISOs into an Xbox 360 compatible Games-On-Demand file format. For Linux, Windows and MacOS.";
    homepage = "https://github.com/iliazeus/iso2god-rs";
    license = lib.licenses.mit;
    mainProgram = "iso2god";
    maintainers = [];
  };
})
