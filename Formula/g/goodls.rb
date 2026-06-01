class Goodls < Formula
  desc "CLI tool to download shared files and folders from Google Drive"
  homepage "https://github.com/tanaikech/goodls"
  url "https://github.com/tanaikech/goodls/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "78f866c19da30d4ade3217673d24e214a86508dd4426dc87fb106d7022f7df15"
  license "MIT"
  head "https://github.com/tanaikech/goodls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dea87403f0d6d536d389bf46f00f979e14f181fe400798e660bb5bd7cf53cd2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea87403f0d6d536d389bf46f00f979e14f181fe400798e660bb5bd7cf53cd2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea87403f0d6d536d389bf46f00f979e14f181fe400798e660bb5bd7cf53cd2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cb2f6dc74efe470151053a6ff1d170f2295632926ae9b47d8a10a1f737ef4bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e092f6ee96b7dadd899b339fa82ae65d84bbfc8aacaee25a38043bfb0db521af"
    sha256 cellar: :any,                 x86_64_linux:  "9fbd14e1e63b5fbc1a526980685b05feb7be3a3ed863ce286a0345072c898a84"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/goodls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goodls --version")

    expected = if OS.mac?
      "URL is wrong"
    else
      "no URL data"
    end
    assert_match expected, shell_output("#{bin}/goodls -u https://drive.google.com/file/d/1dummyURL 2>&1", 1)
  end
end
