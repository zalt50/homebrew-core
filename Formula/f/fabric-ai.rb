class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.470.tar.gz"
  sha256 "bd632fc8681767e76ae86f0fe09401decd7b6d093ea9ecc8171240bc78196285"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53c853923fc5709f1c1fcdfa27c7b40589c72cda3656c8957857dbd09a0f4232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53c853923fc5709f1c1fcdfa27c7b40589c72cda3656c8957857dbd09a0f4232"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53c853923fc5709f1c1fcdfa27c7b40589c72cda3656c8957857dbd09a0f4232"
    sha256 cellar: :any_skip_relocation, sonoma:        "efc4d914461f83f67766d2015d0a1c40696043b9ba395d126c576d7d8ad0e9b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14bab848f1812af8e8fa54432249303997ec2df0c638fd611d539b197f7a04b5"
    sha256 cellar: :any,                 x86_64_linux:  "567a0a09111f0f5fab064d55f35af0d1b6de50edd71e84b4fc5b8f7378740451"
  end

  depends_on "go" => :build

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
