class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "f7feb8fe0b9f66933ec45f8e0e753d5d32a8b31cb1855d32f9a5ba3bd8e7e8a2"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32cc723f57fb9fb7bbe4ae1566a5ca94d3628febd730e2e6055dcdd01431b5f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "32cc723f57fb9fb7bbe4ae1566a5ca94d3628febd730e2e6055dcdd01431b5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "32cc723f57fb9fb7bbe4ae1566a5ca94d3628febd730e2e6055dcdd01431b5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7d11743422cc22ddbd43e4d897fe2e2a5ed14ba6cf5938887c5d1d574df294b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "596dfe87ce7d240641e8d0d49799ae10fd44cc1419065c998bc8a2fd6ac2f396"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/1broseidon/ketch/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ketch", shell_parameter_format: :cobra)
  end

  test do
    ENV["KETCH_NO_UPDATE_NOTIFIER"] = "1"
    html = <<~HTML
      <html>
        <head><title>Ketch extraction test</title></head>
      </html>
    HTML
    result = JSON.parse(pipe_output("#{bin}/ketch extract --json", html, 0))
    assert_equal "Ketch extraction test", result.fetch("title")
    assert_match version.to_s, shell_output("#{bin}/ketch --version")
  end
end
