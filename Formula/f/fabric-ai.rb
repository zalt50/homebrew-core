class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.457.tar.gz"
  sha256 "9093d9b3a98d62edffeb5f5efbb6d4fd7cb3678ac5b383076c5c47d415887044"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc3f86f09cc1bc6a2c267f0a86370839da5c448fe0f60447eb0e154288758eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc3f86f09cc1bc6a2c267f0a86370839da5c448fe0f60447eb0e154288758eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc3f86f09cc1bc6a2c267f0a86370839da5c448fe0f60447eb0e154288758eb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e3bc14f222c209165a5a2a48ef7384b6c33a7934f2de6074917aa304e8cd710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3f9c09b90d40568431ba17f703ca44b0c6b486c733bd77fe9d83604d2e5669b"
    sha256 cellar: :any,                 x86_64_linux:  "8e521741c30747982bcfab3c21345a31a451b3798323917544e46794bf117720"
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
