class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.39.0.tgz"
  sha256 "2a5fec24bb74c09644032a0bbba5f3c89b6bb9fdfc0e77ab2eac678a21e49334"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9add89615ebddac23e370cd74ff6cbc269e4718ff2666d26bd0391e74484850"
    sha256 cellar: :any, arm64_sequoia: "ac972da3e98088688fa7efffb8aa81330b57f04a54b714e502b819aaa339b64e"
    sha256 cellar: :any, arm64_sonoma:  "ac972da3e98088688fa7efffb8aa81330b57f04a54b714e502b819aaa339b64e"
    sha256 cellar: :any, sonoma:        "6965759a8ce81c083e96a11fbe52ff99f20b5894c2c8f4f73deff6cd8ab3c2f0"
    sha256 cellar: :any, arm64_linux:   "850b49eaf8c35eb317b0ed33ad07d4bb8121811b294646544fedc82c11e6fb52"
    sha256 cellar: :any, x86_64_linux:  "81a6b01b4f13403949dd0386e6439942030f018783a16aee2eeb0e2e190fb562"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".serena/memories/orchestrator-session.md"
    assert_path_exists testpath/".serena/memories/task-board.md"
  end
end
