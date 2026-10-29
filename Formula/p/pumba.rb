class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/refs/tags/1.4.0.tar.gz"
  sha256 "74f2b50eb62d83ba33ae0a8d6308c44e65a7080f1f5dea46e247f163a48ea393"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "33a37e1426852e2008e6ef3df325b0d125d4f4d53ca205970f64e0cc00dc7f38"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "33a37e1426852e2008e6ef3df325b0d125d4f4d53ca205970f64e0cc00dc7f38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33a37e1426852e2008e6ef3df325b0d125d4f4d53ca205970f64e0cc00dc7f38"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "99f953cc2bbabc2070b3783bd02994416b5672076246168de24acb41e89a2db9"
    sha256 cellar: :any,                 x86_64_linux:      "596b0274ace51e39d8de9337e94ddc9923c8db7625ff98e5f7d11acf3f483b70"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pumba --version")

    # Linux CI container on GitHub actions exposes Docker socket but lacks permissions to read
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      "/var/run/docker.sock: connect: permission denied"
    else
      "Is the docker daemon running?"
    end

    assert_match expected, shell_output("#{bin}/pumba rm test-container 2>&1", 1)
  end
end
