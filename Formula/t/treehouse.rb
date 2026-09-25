class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3f435bf357e3f32cef0c00d8559f11b89bb8e1efc05fb2aaf529a8aebc39be5b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c86e082d52ffd757686a2d92a095fa5671af8f6d4e81a153b451ea65ebd0762c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0402bccc6eeaae080e411eadc3e2c7811cf7bcd41c78e69b445a4182a41dec2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da33ee021cc6538dd6d8928e939e87de282fec6cac2762d5149a85915847ab75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3356be9607a57db79d0165620adaf84656f1914703cf5fa5ba7a188b63822497"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbc8368a498bd0bc0fecbdd65d0dfcaec6459fc5ebeaddde35800d9c29eae21c"
    sha256 cellar: :any,                 x86_64_linux:      "f4f1cfdebecc68b3cd1100eee7b7bcb3d523fa23d41074afc9bce384fbbb74fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Homebrew manages upgrades, so compile out the self-update check
    inreplace "cmd/root.go", 'os.Getenv("TREEHOUSE_NO_UPDATE_CHECK")', '"1"'

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    generate_completions_from_executable(bin/"treehouse", shell_parameter_format: :cobra)
  end

  test do
    system "git", "init", "--quiet"
    system bin/"treehouse", "init"
    assert_path_exists testpath/"treehouse.toml"
    assert_match "max_trees", (testpath/"treehouse.toml").read
  end
end
