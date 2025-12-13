class CargoShear < Formula
  desc "Detect and remove unused dependencies from `Cargo.toml` in Rust projects"
  homepage "https://github.com/Boshen/cargo-shear"
  url "https://github.com/Boshen/cargo-shear/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "db27000869b63741e4f37269b1012dbc813c2ff0faf3f9415e9fa771dbb2c88c"
  license "MIT"
  head "https://github.com/Boshen/cargo-shear.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ea291ae7d0fec87f651c8d4e22e7a4f23f8e93aafca3131d5250fba93300f8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3072b88b7abc33984f1c65c08aa52ec6fa1990a0343b5332293a04056b3719b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21554ad9687417656e1a63270f6c1e6c9875daf3c96595fdfe9e5e43c5e72931"
    sha256 cellar: :any_skip_relocation, sonoma:        "8846389ab60ce17e0d37f840bd00099da0a8e2b0d546a69a7c55792083b117d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d79c1a32692ad74f81baed1080251a8a3095181eaa6cc24487023cc9effe55c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10c6eef41415af2dd29c6ce823cb32b9ae5f7a448d8d6ba5103e30b091e6fc1d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
        bear = "0.2"
      TOML

      (crate/"lib.rs").write "use libc;"

      # bear is unused
      assert_match "unused dependency `bear`", shell_output("cargo shear", 1)
    end
  end
end
