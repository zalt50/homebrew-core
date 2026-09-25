class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.482.tar.gz"
  sha256 "39ca858efe2af255c5331ec35cc4399dfc63fb32261615b6e660c06987180272"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d3cae8dc798b7805b06575cc17ef8ebfc0926bdafe4ef7a03b111bd5a1544ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5d3cae8dc798b7805b06575cc17ef8ebfc0926bdafe4ef7a03b111bd5a1544ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d3cae8dc798b7805b06575cc17ef8ebfc0926bdafe4ef7a03b111bd5a1544ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e257db8be6dc1f993993c0097a5d37749e5828f93f43048839629b651c0b60a6"
    sha256 cellar: :any,                 x86_64_linux:      "32a4a2f428fc009da511d3d77358dd170464f1810d36cf46cf95f57fde1a364f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/fabric"
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
