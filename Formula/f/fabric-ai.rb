class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.463.tar.gz"
  sha256 "d81ef83ba82d187faa16a353b4847580dfe67f1c14de1221dc8481a581eb2bf6"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f642cc59be17ecd5121ab9d4f9368d8f58cc9b8f15e5dc594439b54d168a2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f642cc59be17ecd5121ab9d4f9368d8f58cc9b8f15e5dc594439b54d168a2d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f642cc59be17ecd5121ab9d4f9368d8f58cc9b8f15e5dc594439b54d168a2d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "5faed604980379d3e43f870ed850b319a0763ab701970e4fbce2f7632a0a9470"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19cdb1df9f7cc72b4dfdcfb59fb313caa4ff2d3da0482c302f4569bb3b99527d"
    sha256 cellar: :any,                 x86_64_linux:  "3fa516ddaefc26dc63753b86f315e518c4d6b50ffd53b94340ec07467f9b1fba"
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
