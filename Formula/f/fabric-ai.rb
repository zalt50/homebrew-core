class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.377.tar.gz"
  sha256 "ae98a27866196f147e355405d64b857ca86d11751d592bd406777ead0fbba066"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2225492ff57363ea41233f2964e19edae55487165562b92d42839e1f8c19ace6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2225492ff57363ea41233f2964e19edae55487165562b92d42839e1f8c19ace6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2225492ff57363ea41233f2964e19edae55487165562b92d42839e1f8c19ace6"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c2cf606630bc0c206306e90a4e46800c355414990938b49ff38dedb68e2e52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "462f04795d8bade91b64b1cb5ed2cea75d11973fff4e7f8c50c5559c17e18682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114d2d791a45cb78871931ac5bd0ad56f9665dcf6d3e3c49b247224f77cfae48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
    # Install completions
    bash_completion.install "completions/fabric.bash" => "fabric-ai"
    fish_completion.install "completions/fabric.fish" => "fabric-ai.fish"
    zsh_completion.install "completions/_fabric" => "_fabric-ai"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end
