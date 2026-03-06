class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.431.tar.gz"
  sha256 "bfbaef13a6c1623b1f7d57d02780f24f8ff5ffa62c08399c3ed4e8548725be4c"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2f893afe0d396b3947f69b4bb7428cf5eb9925bfe8852d13d773cc4637bd5105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f893afe0d396b3947f69b4bb7428cf5eb9925bfe8852d13d773cc4637bd5105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f893afe0d396b3947f69b4bb7428cf5eb9925bfe8852d13d773cc4637bd5105"
    sha256 cellar: :any_skip_relocation, sonoma:        "373ab040d8e0d44c5232275321fd663fbfac80138879409e2a3ee73f28a6d797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ff5076326331553edd580260afbf5ca0aff915330264f0504fa95b9b6643f7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f0271fe99eed42b4f88e2019932b81bc340c982a5e33ea0aa28af45b77ef954"
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
