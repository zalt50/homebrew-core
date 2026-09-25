class Treehouse < Formula
  desc "Manage worktrees without managing worktrees"
  homepage "https://github.com/kunchenguid/treehouse"
  url "https://github.com/kunchenguid/treehouse/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3f435bf357e3f32cef0c00d8559f11b89bb8e1efc05fb2aaf529a8aebc39be5b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea77a809ed883f79f8f2520f93f70f622a1e7dc1c075469458de80d0b29e7da4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f1d51ab04784aaf6d8846815ec68595b731187bd3fb9f2c236375514e4fe93b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2fec662cc2aa5c1d0b7a710a61d890877b9610700503bb20eabc432ae125090"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e73078d22f48642b9bd11e50f6f0210ade75c8b0882db097568a9b9c2753850a"
    sha256 cellar: :any,                 x86_64_linux:      "6c17afbc25c1d57dd67023df6364855f7b0c1421366aca6c7837584aece50827"
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
