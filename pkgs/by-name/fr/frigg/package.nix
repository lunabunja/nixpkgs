{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  stdenvNoCC,
  buildPackages,
  gbenchmark,
  gtest,
  meson,
  mimalloc,
  ninja,
  pkg-config,
}:
let
  attrs = {
    pname = "frigg";
    version = "0-unstable-2026-06-08";

    src = fetchFromGitHub {
      owner = "managarm";
      repo = "frigg";
      rev = "65db297ebd6db09e86fe737175631a872d81c39b";
      sha256 = "sha256-Jp/tzwYVmfbVh81K1GvHXOQJJnN+yNfr54iEPEEJ+s4=";
    };

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];

    checkInputs = [
      gbenchmark
      gtest
      mimalloc
    ];

    strictDeps = true;
    __structuredAttrs = true;

    meta = {
      description = "Lightweight C++ utilities and algorithms for system programming";
      homepage = "https://github.com/managarm/frigg";
      platforms = lib.platforms.all;
      license = with lib.licenses; [ mit ];
      maintainers = with lib.maintainers; [ lzcunt ];
    };
  };

  withTests = stdenv.mkDerivation (
    attrs
    // {
      doCheck = true;

      mesonFlags = [
        "-Dbuild_tests=enabled"
      ];
    }
  );
in
stdenvNoCC.mkDerivation (
  attrs
  // {
    passthru.tests.self = withTests;

    mesonFlags = [
      "-Dbuild_tests=disabled"
    ];
  }
)
