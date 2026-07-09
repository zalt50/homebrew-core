class CargoDeny < Formula
  desc "Cargo plugin for linting your dependencies"
  homepage "https://github.com/EmbarkStudios/cargo-deny"
  url "https://github.com/EmbarkStudios/cargo-deny/archive/refs/tags/0.20.0.tar.gz"
  sha256 "9eb0207a2c5f998b3fe0df225365b1d2ac5a8077d96f8646617d8ac2478ab69d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/EmbarkStudios/cargo-deny.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7de3f47ae36aa04703017233ca815e431b67689459202080a563f90cf44d407e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04fc5208b2116a19d1a5703d4ffdaeceeaa42f3b2d5625f91f90c5fee757bb35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "661cfc03c25a86ec8da0cc7a14f72b0589a6f69490aef4c7c119cdd7c2609225"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f9d46da1ac4aac4fdd8d2c02c26c29523743caf07f745d763f04621d17e5a3b"
    sha256 cellar: :any,                 arm64_linux:   "1251d142c70aec47d0d2ec2927a5f95c56c5ab998ed82a08adb41f61c8b71238"
    sha256 cellar: :any,                 x86_64_linux:  "7cdf7e3fda49659f04d06fe4e2a66131343ccbb5ccd6267e9985ec3f5bc515d6"
  end

  depends_on "pkgconf" => :build
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
      (crate/"src/main.rs").write <<~RUST
        #[cfg(test)]
        mod tests {
          #[test]
          fn test_it() {
            assert_eq!(1 + 1, 2);
          }
        }
      RUST
      (crate/"Cargo.toml").write <<~TOML
        [package]
        name = "demo-crate"
        version = "0.1.0"
      TOML

      output = shell_output("cargo deny check 2>&1", 4)
      assert_match "advisories ok, bans ok, licenses FAILED, sources ok", output
    end
  end
end
