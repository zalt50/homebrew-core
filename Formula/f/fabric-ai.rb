class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.371.tar.gz"
  sha256 "449c1b43be885962dc7b81a39dd83ffdfec45f0f1cf704e748d59deb4cc58a39"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a3510f57b35aed663838da053ae8cc24bb8a73912680f52c68cf7c9e2e59c61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3510f57b35aed663838da053ae8cc24bb8a73912680f52c68cf7c9e2e59c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3510f57b35aed663838da053ae8cc24bb8a73912680f52c68cf7c9e2e59c61"
    sha256 cellar: :any_skip_relocation, sonoma:        "53570fff025ca5d79c64d27cb981c96fc223cb0412b929ee7bd7ab4b7cc1fc85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c796b439c9acf9013315bf07df5097398250ed83b77f5065554b9af112f6f80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7548b6249293de1e4bea21aa9a3711b226089ccf2680553107f1891e9342f811"
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
