class Nanobot < Formula
  desc "Build MCP Agents"
  homepage "https://www.nanobot.ai/"
  url "https://github.com/nanobot-ai/nanobot/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "23fe611b9c6fbc1a920ace9b276a25d225afab12d0a10eb130793d31ee934761"
  license "Apache-2.0"
  head "https://github.com/nanobot-ai/nanobot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5410199edab2f9ea28d6c9feeb10ac6ba45f97b1e2d480729061adc9c59d5ee1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5410199edab2f9ea28d6c9feeb10ac6ba45f97b1e2d480729061adc9c59d5ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5410199edab2f9ea28d6c9feeb10ac6ba45f97b1e2d480729061adc9c59d5ee1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a0c493f2ecadee09ebde4a4f1c072c2bdd05b59fe1f3643c00b610eccd97429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84296c12303df630fb0b43f61181adcaa50d45baad22591a48c12863be4a834c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eb79c4679f3660adf767d0d63ab0d050877a2d48f414aa3905540ad57b37496"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nanobot-ai/nanobot/pkg/version.Tag=v#{version}
      -X github.com/nanobot-ai/nanobot/pkg/version.BaseImage=ghcr.io/nanobot-ai/nanobot:v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
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
