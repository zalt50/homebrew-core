class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.349.tar.gz"
  sha256 "259e27c9acda7e3996c2d72adce8be3d3b4346a7f1c4db8bfcfb96d7049e35ec"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "468e4f4f88bd3c93633ea24ae60e0b00b749fdd972e3cd99beebfdd6d6c7b0d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "468e4f4f88bd3c93633ea24ae60e0b00b749fdd972e3cd99beebfdd6d6c7b0d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "468e4f4f88bd3c93633ea24ae60e0b00b749fdd972e3cd99beebfdd6d6c7b0d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "38554a5beaccb793c440b4509b7a6e05b56f52e29d91f670c43a2f748338525a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ddb69ff73fb1ad34eac699a18513a4ebe8849df29315d13b3e414b038f5f898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a136cb2f8a9dbedb6a9012ebaedaff40978f7fcf2e688691fd242b0159f6ad4"
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
