class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.323.tar.gz"
  sha256 "989f4c0c3c75e2da333f7bf1070d09950f5d065e597c7ebb996e497d3aa6eb79"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1632c27be5c9ca5df9da305a1ace97edba216c438836f16bd0efb1af9c73656f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1632c27be5c9ca5df9da305a1ace97edba216c438836f16bd0efb1af9c73656f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1632c27be5c9ca5df9da305a1ace97edba216c438836f16bd0efb1af9c73656f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0d285607e9b5c859e3af307d51361862fdcd055faac41f08d442b0dbae09a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b61c198731b720f709b57873b8f20551cf2ec9ea2de5c7c0fbb96c3a47c0c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c28f101245d1db3ea940fdaa40dc581ef522a4396669d9a76bfd4cfc1daaa99"
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
