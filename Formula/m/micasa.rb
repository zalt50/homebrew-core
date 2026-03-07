class Micasa < Formula
  desc "TUI for tracking home projects, maintenance schedules, appliances and quotes"
  homepage "https://micasa.dev"
  url "https://github.com/cpcloud/micasa/archive/refs/tags/v1.69.2.tar.gz"
  sha256 "4260aff134c403454606eed33fee7300be430c4d29e44536f7954b4318b53504"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a7f0211a0bd78192b598d524b699700e7ef980c5d5f10e2be8453c1c53d96b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a7f0211a0bd78192b598d524b699700e7ef980c5d5f10e2be8453c1c53d96b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a7f0211a0bd78192b598d524b699700e7ef980c5d5f10e2be8453c1c53d96b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b864cb3833fc7e488f9359d7d3c6b059a45199f49d5fbe21ed23ce1dc0436c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4db228fb58d85bf02ac8603b4ccb0d1483a7210d4d7d08e2f8e9ea5f82edc0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3bc2bbd1f42fa1655053abf990e7fab22aaa6f8b0d5cd1daf6768a2f7798f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/micasa"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micasa --version")

    # The program is a TUI so we need to spawn it and close the process after it creates the database file.
    pid = spawn(bin/"micasa", "--demo", testpath/"demo.db")
    sleep 3
    Process.kill("TERM", pid)
    Process.wait(pid)

    assert_path_exists testpath/"demo.db"
  end
end
