class Kdash < Formula
  desc "Simple and fast dashboard for Kubernetes"
  homepage "https://kdash-rs.github.io/"
  url "https://github.com/kdash-rs/kdash/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "81483cfcacb68ea04a278d576265eba786f44b3d1a7915efb7293e35b4d746f0"
  license "MIT"
  head "https://github.com/kdash-rs/kdash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdd8ab76b752910ca43b0857d1e011493f0688d1f17b72c713a61b3d7e713383"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baa1194af51dc85294bcae8ce7584fe4521257d42f7eee8a0d28834f50515a6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cd56a7bd3234cc7f6f283d10a5e0ab34be054a2cf1bf9ed0ae5bf1bbce6ae37"
    sha256 cellar: :any_skip_relocation, sonoma:        "3416672ea21eb8c398d1cff8455b98043296f9b852fbea40369156a7cadbe270"
    sha256 cellar: :any,                 arm64_linux:   "a99ee490dec131fca847a5129fa3bd5d53ae04c5a53a85129b16643d940d1b36"
    sha256 cellar: :any,                 x86_64_linux:  "9be007dabbb68a50b3747bed3b636095bbb28990546a5f2ff741232ad1efe265"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kdash --version")

    require "pty"
    output_log = (testpath/"output.log")
    r, w, pid = PTY.spawn("#{bin}/kdash", [:out, :err] => output_log.to_s)
    r.winsize = [80, 130]
    w.write "\e[80;130R"
    sleep 1
    r.close
    w.close
    output = output_log.read.gsub(%r{\e\[[\d;?]*[ -/]*[@-~]}, "")
    assert_match "Active Context", output
    assert_match "Resources", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
