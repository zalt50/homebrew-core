class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.353.tar.gz"
  sha256 "4102e703494949b3236b30e45cdddac8a0d2f146b69e1bae36afbe0f648038dd"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93b1b5c207cc78c446fa6ee7900aa9e4e26f3c3c546442820920ca6590837a9a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "93b1b5c207cc78c446fa6ee7900aa9e4e26f3c3c546442820920ca6590837a9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93b1b5c207cc78c446fa6ee7900aa9e4e26f3c3c546442820920ca6590837a9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ec15ce8dbc586bac77901035b5e5acc7526d79e98ffaf77a66a4480e4b3b2bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e85ebc60dca3001d7752f33870287719c9ec7d2f82258349d0a3e8a13f16f7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c5e9d0626a360f2a4a893edc7e7eb528088aa48f719c0961015c810b2985a5"
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
