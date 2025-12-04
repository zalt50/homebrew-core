class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.337.tar.gz"
  sha256 "5fe70674dbe3ce6b2d477c26d25e9a268d70552ff55e5fdc8a3291a6db50d19a"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34e0ef8d935a0c184596dec5454cdb2a5f0695d4e125cb239866553c126adefc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34e0ef8d935a0c184596dec5454cdb2a5f0695d4e125cb239866553c126adefc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34e0ef8d935a0c184596dec5454cdb2a5f0695d4e125cb239866553c126adefc"
    sha256 cellar: :any_skip_relocation, sonoma:        "914f6e0f3ecd64fac54b26d4ecc42353ca85fe80cd423ebea990db196e9616b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc480e98fa77c25b2c9f1163be48ed1c72aa06ca4142a0de92bd5ef863eb1d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a02c363663752950918c0b576645f6b47562f57ed120ae9e10d315465abbe4fa"
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
