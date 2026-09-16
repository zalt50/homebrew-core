class Ketch < Formula
  desc "Web search and scraping for agents"
  homepage "https://github.com/1broseidon/ketch"
  url "https://github.com/1broseidon/ketch/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "aee5de0d4bb93100f60e8828d24eabd6403c006563c0c4735421a36152f048eb"
  license "MIT"
  head "https://github.com/1broseidon/ketch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc4e5a0dd9227d425fd1ff526de54e31b4ab931e0b2935d4828299c31eefab1d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc4e5a0dd9227d425fd1ff526de54e31b4ab931e0b2935d4828299c31eefab1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cc4e5a0dd9227d425fd1ff526de54e31b4ab931e0b2935d4828299c31eefab1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8412e9669abe2e514b9d5735bebb651fbc8b80436513a99dd298fe9bfd9bcb35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "78c1fae1cd421dc9897b28c7c3b7bb88add5d470b27f691d6f44aa727936562f"
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
