class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.510.tar.gz"
  sha256 "48a63a02b9129b6d2093e392d7a1a66fa9cc1af4d1951278d6fb2f660953a754"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "687f0aacd510fb146455c2c608584c01e9692100a9618db9cb402e06bfee6db9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "687f0aacd510fb146455c2c608584c01e9692100a9618db9cb402e06bfee6db9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "687f0aacd510fb146455c2c608584c01e9692100a9618db9cb402e06bfee6db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5dfa3776cd4dc99759bff29232a48d93f6c80aa0514649a41ad6867657a4826b"
    sha256 cellar: :any,                 x86_64_linux:      "64d0226fbbccc9e54ed8d097e81c35bef4b364d3ded4ac4fda02f2f6117f1393"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
