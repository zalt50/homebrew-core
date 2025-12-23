class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.357.tar.gz"
  sha256 "8790548792429cee0fe7ecaba0e08c9a6e213376098e4ca4a1c0ee3db562a976"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5286211905beb4e2da947a1e665fe17433a56e5a7cee56b3e1eb68d1294c0e46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5286211905beb4e2da947a1e665fe17433a56e5a7cee56b3e1eb68d1294c0e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5286211905beb4e2da947a1e665fe17433a56e5a7cee56b3e1eb68d1294c0e46"
    sha256 cellar: :any_skip_relocation, sonoma:        "a94841c780e0798270c700703a6177ee94a2af2ccc1c7443e060d6dbe41431be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c3f64fa9406d1fa7eda355ebc6b6240aebc11e8b5354ad65f825ef09818aab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15e662404f138f3b160b7d37b3dcfce7f036fe28b34128bde321d362e83d0ea0"
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
