class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "eeb1ca2de798547e4721bed8064a2e81c389f252e8c344fc46eee2e405fc7160"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "355dced8bf0cd37a456ba1f040cfc8c0b97ec7381b528697419fcfbd41b2de27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86e5eaa5c109ec088a0eb624059b1cd9dd910719a48544c065c78df86f8ecc59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5beb289eb4552984e582b5779e2630a148b6ce75bb66e84db69f0b0d42a0f0b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c462039547b1517e04b1409e816d81a4794b8b0dbd9aa1cc5af1a9bdef91f28e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4edd1780f376ee575ce92cd6ab52a4d8440a1e70c2c13b4026fb51ef747d2481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "511b0024483162af37ceafa3f245f44674cb14bb144e84c88593d6888140fa46"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end
