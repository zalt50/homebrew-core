class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "711c5cd96591f8acb1edda9511c421b7a0383b76cc742a4f9d8d5515e91c40bd"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dbac191186ce6c6e7e4d1a649e2e438684f13a5878b23a75b5c6fc7f91c80f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece9a2c681fad38187b0417c904b80d23583879155e260e78f332930281eb54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee7fd025cde5661b813814e8329303ad3f0b044c49c39adfed6a7f35a08fb98a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfd99084538b1cca89f2b12c99c69a48d25c6b6a45c2f2361d52a68596d6a7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52de0a939305b55f1f6d25a2cc42f81a8ae9820c4986f6642a3c7d32fa56845b"
    sha256 cellar: :any,                 x86_64_linux:  "1130c627965e49b0e62c0ce655bbb40d1b725c4758ee575ac72e0734a8d8776b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end
