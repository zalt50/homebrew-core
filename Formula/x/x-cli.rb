class XCli < Formula
  desc "Command-line power tool for Twitter"
  homepage "https://github.com/sferik/x-cli"
  url "https://github.com/sferik/x-cli/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "30685de7d87d385a1c74b6ef47732c8b5259fe50f434efd651757e5529cc2fe9"
  license "MIT"
  head "https://github.com/sferik/x-cli.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # https://github.com/sferik/x-cli/issues/475
    inreplace "Cargo.toml", 'version = "6.0.0"', 'version = "5.0.0"'

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x --version")
    assert_match "No active credentials found in profile", shell_output("#{bin}/x whoami 2>&1", 1)
  end
end
