class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.362.tar.gz"
  sha256 "57c0cb42d45c92ffa9b37d18ccf68b283cfdd59d025daa02d0615fea1d7e46bd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d62b949b824b52b2bfc60869fc9fe07d6732ef0bcf8eeba3bda6da243177593"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d62b949b824b52b2bfc60869fc9fe07d6732ef0bcf8eeba3bda6da243177593"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d62b949b824b52b2bfc60869fc9fe07d6732ef0bcf8eeba3bda6da243177593"
    sha256 cellar: :any_skip_relocation, sonoma:        "deff5f0c458fa5d22ba32ca6e7d7428a4945cc5f73b7bfdbb29827c8fe178910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4387f19c0064615d1dbf04ce5a673a9de2389d6a7506e454927beb17fb0a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c089b20ae8f628250ea9afd9727832b6ae7e578ecd938035c41dc3dc8f8c2e"
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
