class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.365.tar.gz"
  sha256 "9ab0a4e0b312762de7163d1022e9046ddf68003fa1705c2b607ff7e41ea3fe19"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce82a3b2dbe1687050b97df257740a39b42fd96ed811689e2ee38cb899ff87e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce82a3b2dbe1687050b97df257740a39b42fd96ed811689e2ee38cb899ff87e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce82a3b2dbe1687050b97df257740a39b42fd96ed811689e2ee38cb899ff87e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b4cda3ee89e6957009331ca442fdfa66a7b2c759f48b864d73057670ef50094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964acda41901820e6069b702f6f0ab70416edf99f470e4083bdecf22c7a24c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3464b9500a95cb987ed9e6f0974058c4b173683aec7b74a41d800bc9dc6ce016"
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
