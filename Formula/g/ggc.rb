class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v8.6.1.tar.gz"
  sha256 "7649ca013907b76b286352e6d6cc35dd0d21ffa848b4a8ccf74bb66a3e5d0dc7"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b6280a67f4f9cc1e24a4291e50488e9029d312992a634f0b4ec7d07d8af029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b6280a67f4f9cc1e24a4291e50488e9029d312992a634f0b4ec7d07d8af029"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b6280a67f4f9cc1e24a4291e50488e9029d312992a634f0b4ec7d07d8af029"
    sha256 cellar: :any_skip_relocation, sonoma:        "8aa25e283a513b15a8465d24e7e0f427efa25e322f841b4c97a49c0c02653bd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fc502c78992dccacfb420a5765c5e43e067db82ab54639f903b7484067fec7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7d4aaed238ff74aeb85e687ca20976911c2b6870612e88619559531d719ea8"
  end

  depends_on "go" => :build

  uses_from_macos "vim"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
