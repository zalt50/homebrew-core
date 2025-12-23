class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.358.tar.gz"
  sha256 "46902f43f71f233602bf4f336fe4d0870f7f5e20e6ec6dd4d55c5b5994ebb9ee"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae91c0613080acc106e5672d81aedba803aa7bfe9642b7d8493c4aff8ab4432d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae91c0613080acc106e5672d81aedba803aa7bfe9642b7d8493c4aff8ab4432d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae91c0613080acc106e5672d81aedba803aa7bfe9642b7d8493c4aff8ab4432d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7173ac91a65f4f5a0ab76b2f7aa3957032b6ab86da309119ad0facc46f27b99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee4dfd03c13d6260b8096c3f5da4c55070d61088c443dff37c4b4824b0dbe0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c6e5d29ed4e44e3a8509eca0f06778f961aac85b81b107a75b79f83b03abd48"
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
