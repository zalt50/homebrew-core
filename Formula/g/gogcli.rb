class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://github.com/steipete/gogcli/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "e5e6ffa881222e652eacf037df4b65f8f53149215fe72160069e8e983d753a1e"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "721b6c15f35efba2035cc68f6002508b1af18fd06e5a40efcaa68761ecf9b8d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "924d07853951534e82a80667534e3fa3cfaef596e23e865573dedc88b174dcec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7752df82e0f88fb270d32ccf6b1ae39cc70a25478a45fba01bf8c885be9c9cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8dd7a56cba4d8577ae8f80c025e691ad77f3b15da4efa778c9930c717f4aad4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48a955fcd514ccf1233937c4ba55b3747104db304aa9f9b348346e2cbb5fb25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9ccdabcd12ccf747b4ec9877d2ea1db854226493f10e14dbd3720dfc4841cc"
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
