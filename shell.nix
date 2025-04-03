with (import <nixpkgs> {}); let
  env = bundlerEnv {
    name = "WillemToorenburgh.github.io-bundler-env";
    inherit ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
  # in stdenv.mkDerivation {
in
  mkShell {
    # name = "WillemToorenburgh.github.io";
    buildInputs = [env];
  }
