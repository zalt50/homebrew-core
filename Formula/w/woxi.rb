class Woxi < Formula
  desc "Interpreter for a subset of the Wolfram Language"
  homepage "https://github.com/ad-si/Woxi"
  url "https://github.com/ad-si/Woxi/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "49d24f0a497211494271ed5d442cb191cbac1d661105f0de510e31ccf41cff21"
  license "AGPL-3.0-or-later"
  head "https://github.com/ad-si/Woxi.git", branch: "main"

  depends_on "rust" => :build

  def install
    # Linker config for the upstream nix dev shell; lld is not available.
    rm ".cargo/config.toml"

    system "cargo", "install", "--bin", "woxi", *std_cargo_args
  end

  test do
    assert_equal "3", shell_output("#{bin}/woxi eval 'Plus[1, 2]'").strip
    assert_match version.to_s, shell_output("#{bin}/woxi --version")
  end
end
