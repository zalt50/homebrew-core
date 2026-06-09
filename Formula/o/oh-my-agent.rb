class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.46.0.tgz"
  sha256 "a98ead1fe6c431290b428914e6976a63b3c9d1e5570ac3d71da3f8ea2f2c487c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8a1518310803e5f4afd3dd537cfb44025dc1f7d613d1b066e577aad381d51bc"
    sha256 cellar: :any, arm64_sequoia: "0037b6d3f1c9d3ef11cee824a51e65a5298281ea93f9ab94790c51d4d0b8779b"
    sha256 cellar: :any, arm64_sonoma:  "0037b6d3f1c9d3ef11cee824a51e65a5298281ea93f9ab94790c51d4d0b8779b"
    sha256 cellar: :any, sonoma:        "2ef9ef053821889918bb1b98b5033c8a5d7be544535d5251c5c772d2d9b30c01"
    sha256 cellar: :any, arm64_linux:   "80c80e34aaca0f617d07db4633dc200ce3b3b7f623287f3754df78d090e1beb1"
    sha256 cellar: :any, x86_64_linux:  "cf0b350b606908043bf9e0d4db550db25281babf648ca68f17ac9d599c1b1e61"
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
