class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://github.com/danielmiessler/fabric"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.354.tar.gz"
  sha256 "740d58e397cacf2238d18eb05b554c68365b7d787ec219d6f70749ad17b1a8c9"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd0ade653ea52c37c016f36f99a45ca49e0c1a9dbf73054d8c207654885fa4d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd0ade653ea52c37c016f36f99a45ca49e0c1a9dbf73054d8c207654885fa4d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd0ade653ea52c37c016f36f99a45ca49e0c1a9dbf73054d8c207654885fa4d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4596410363adb566ed3ff9701b757ce736140dbea244f7f8058e1eabebb74c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f8f0d177f8cf0162b3da8546d1ed93c0e672c3e3b71f63c5df8df4333ac73e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c762959fb4443d30f91fc90e75a7baae492516732aa8de459c3f9d717fbcf94a"
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
