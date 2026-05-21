class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/obot-platform/nanobot/archive/refs/tags/v0.0.81.tar.gz"
  sha256 "697434d6612f2afb9e490d24530024fc2771065d4130f1a40c9c7939b76254d4"
  license "Apache-2.0"
  head "https://github.com/obot-platform/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68584bf47e9a139d45928e304c8438b614dcf1699cad5b4c3c42f45dab3e70ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73602e1788bde1feebb3d6eceb49f6b5b01603656f59877f44a28ce4f6a66375"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c21dccf51d69ed0158f659c45840082f5c72f8298a5a6f6308a6a427f24bacef"
    sha256 cellar: :any_skip_relocation, sonoma:        "de78617e18f7d749a1956f4609151e0ff880c08b832806e21a969627f0ab2c5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ba3f3a28d4dee06455190b9ff9c37e70cf9d2af32fadeef91a306f81e3f2913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac9286975858454fa48755bad17676546766210d87a99783edd1cda2eada4a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/obot-platform/nanobot/pkg/version.Tag=v#{version}
      -X github.com/obot-platform/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"nanobot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nanobot --version")

    pid = spawn bin/"nanobot", "run"
    sleep 1
    assert_path_exists testpath/"nanobot.db"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
