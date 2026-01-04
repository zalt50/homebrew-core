class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.371.tar.gz"
  sha256 "449c1b43be885962dc7b81a39dd83ffdfec45f0f1cf704e748d59deb4cc58a39"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde4b098729d9cfb642a13b6e878cc5c680bfa04cbba26aafad11dca9d23e5e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde4b098729d9cfb642a13b6e878cc5c680bfa04cbba26aafad11dca9d23e5e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bde4b098729d9cfb642a13b6e878cc5c680bfa04cbba26aafad11dca9d23e5e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b3b37b5aa6ae5f512f52d83a8ca8800809cca9aa476fc5f39fd80379f866b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c23e33d9354cc9b63a19cbfd96d275d265a0ee77d947eca11c577c5851b0c74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5921aede6596463bf4567b8348c86c33e8233337603e3061ba06a863444a57f"
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
