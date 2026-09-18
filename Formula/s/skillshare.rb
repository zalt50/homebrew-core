class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://github.com/runkids/skillshare/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "6937a40ba2a6155dcd74a3ccb8fc7cc9e914bc8183b22e203459686ecdf6fc9c"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1cd6c283d1e29276f32390dd335e36cb6f76b557b6a33f6f28b3043a2b0e6568"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1cd6c283d1e29276f32390dd335e36cb6f76b557b6a33f6f28b3043a2b0e6568"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1cd6c283d1e29276f32390dd335e36cb6f76b557b6a33f6f28b3043a2b0e6568"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1cd6c283d1e29276f32390dd335e36cb6f76b557b6a33f6f28b3043a2b0e6568"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "207f2bed013ebf9a1bc831b938ca539d6ae978acc2ebd0d11d911e4d26d56845"
    sha256 cellar: :any,                 x86_64_linux:      "d1ed2d103a25fb68298dfcf99a707c1bbb089ef6119e04637feef875cb94c448"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end
