class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.381.tar.gz"
  sha256 "f773b4e5eef37ca23ec06c1913351da0d576c4ad91dd526a988309d3ed592899"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f25b1ed71a3fba85893561f03dced176c95b7adecd66899c2c4444405325cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f25b1ed71a3fba85893561f03dced176c95b7adecd66899c2c4444405325cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78f25b1ed71a3fba85893561f03dced176c95b7adecd66899c2c4444405325cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a38f7b191812ec17a3ed7bb99fd255d23ffae4ac8a112f73ac9c948b40b92472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b079ad2c9ebaf06429d705b32b0d453d641480945af392675fcc2a21f2d1de13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa02ebd2a9311e57ad2f7b87a0002380f3b6284db9add0b7a6793a410b8626e5"
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
