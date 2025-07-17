{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}: let
  pname = "xremap";
  version = "0.10.13-xwayland";

  src = fetchFromGitHub {
    owner = "loystonpais";
    repo = "xremap";
    tag = "v${version}";
    hash = "sha256-43jaX+H5ZSaHt+ZXHF7Tr6sN3hnvaI73hGbOnzb5U4U=";
  };

  cargoHash = "sha256-m7K47XjOO5MoCFTXYNovXm8GI2r66+UKvLV5aoCZIH0=";
in
  rustPlatform.buildRustPackage {
    pname = "${pname}-xwayland";
    inherit version src cargoHash;

    nativeBuildInputs = [pkg-config];

    buildNoDefaultFeatures = true;
    buildFeatures = ["xwayland"];

    useFetchCargoVendor = true;

    meta = {
      description = "Xremap fork that works with clients running under xwayland";
      license = lib.licenses.mit;
      mainProgram = "xremap";
      platforms = lib.platforms.linux;
    };
  }
