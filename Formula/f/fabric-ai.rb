class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.362.tar.gz"
  sha256 "57c0cb42d45c92ffa9b37d18ccf68b283cfdd59d025daa02d0615fea1d7e46bd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa090f829b5c86e6d270460df5cc4e7fbcba1d51e1a19da4fc7e1ea0a3f62dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa090f829b5c86e6d270460df5cc4e7fbcba1d51e1a19da4fc7e1ea0a3f62dc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa090f829b5c86e6d270460df5cc4e7fbcba1d51e1a19da4fc7e1ea0a3f62dc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "99681f4889250f3cd72c6be027ebed307e57eb64792fdde2730aa8d94b6389b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10be2ddd09ba63224d18bcd8dc533a8fd0597927d908b4d35a7c5a068acb66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "611d498ac9955a6e168a161b0c956b4e05a78492abf50442b3925059d2954043"
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
