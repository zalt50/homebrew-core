class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.326.tar.gz"
  sha256 "34236918f8b3b6fa7d162460f744e07ba7f44f95135ad7bd2b324d823fe6ba54"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80ff94e3c3c94d1ff9f7f8c96059019d539d388503f96323d4c6896812a52a17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80ff94e3c3c94d1ff9f7f8c96059019d539d388503f96323d4c6896812a52a17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80ff94e3c3c94d1ff9f7f8c96059019d539d388503f96323d4c6896812a52a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "da0c96e0f93332afa59b2eee14c9acf722f4d4b89b338edd9a6db4c11e6dbae2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23470f065b49ba6dd120fd3331e4f1ddf5a9725dc0b9911009e84ff94ee3777e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32c08802d2c93d591765806854a93fff1697a84684bdb2dbbe6316f5eadb1d37"
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
