class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.484.tar.gz"
  sha256 "bfe2af7c3d086dc654fd69c2a7ec17683d4070c9921da843cf080a865aad6e4d"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e38c6af8adeace7755c450d6b80458d54cbaf2508f6773903164d91bdc5115ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e38c6af8adeace7755c450d6b80458d54cbaf2508f6773903164d91bdc5115ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e38c6af8adeace7755c450d6b80458d54cbaf2508f6773903164d91bdc5115ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "397b60d3cd4892c852376e5e154f9c0c70b170eafe02e2399fa3125f7b8a412f"
    sha256 cellar: :any,                 x86_64_linux:      "da8c60539c4e1c9cdd177c087d5c8259ec9cdce09dfb66795d9ded8a0874074b"
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
