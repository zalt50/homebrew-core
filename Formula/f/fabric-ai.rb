class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.494.tar.gz"
  sha256 "21a64d54138407c8c9c734e44953b08af29b7bf8ddc359183ce9690a5c4af698"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "70b8ef7014c2679f615c396bbbb56d50084221eee357d099125ce417c469de99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70b8ef7014c2679f615c396bbbb56d50084221eee357d099125ce417c469de99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70b8ef7014c2679f615c396bbbb56d50084221eee357d099125ce417c469de99"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f27e6013c6fb678d0a77868448b1f1cf7a19a29d358bd8b5df00980d5a30d4a3"
    sha256 cellar: :any,                 x86_64_linux:      "f0ffbdef33c7cc2edbb88b13f57a34faa78734091b5c261c94c8a888f30afbf2"
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
