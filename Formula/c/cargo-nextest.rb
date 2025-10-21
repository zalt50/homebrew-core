class CargoNextest < Formula
  desc "Next-generation test runner for Rust"
  homepage "https://nexte.st"
  url "https://github.com/nextest-rs/nextest/archive/refs/tags/cargo-nextest-0.9.108.tar.gz"
  sha256 "d9aa0ae604e4a6ec4ea0249ae8271a557b05a2fc384aba139a23f7473dbc45af"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cargo-nextest[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3712def372a15a86b60b15f3fb2cd473f96f3c017d237f767c53bb5c3921d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93ecf7a2e7caf763c638571e9094217036d588995370363fe5a8f088409f71e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d2a8ceadba224c2911259fa7bffd22cf87fc8b8846ed551cb7a5469c9b5942"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a931ee2c1f25ba552fb4b25d6d61871edcd37214dba0d7fd816f2026ae2b452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62d1b7f5889098a66a1e760efbcc1ed38274fd91ea058cdbbd07b152deee73e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "423b2a319a6bdde4b280e098912c05ad340dabdd0763cc57940c4ef6ac581127"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", "--no-default-features", "--features", "default-no-update",
                    *std_cargo_args(path: "cargo-nextest")
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

      output = shell_output("cargo nextest run 2>&1")
      assert_match "Starting 1 test across 1 binary", output
    end
  end
end
