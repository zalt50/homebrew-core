class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.3.tgz"
  sha256 "258882d1ca7a3ada63892a99c2ac21f84e44fc5da6797f51fefa6c48921325b7"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "379d5488b50ab8db9a834a03bee110f3adf76381be1f24b3ea5cc83b4aca79ca"
    sha256 cellar: :any, arm64_sequoia: "781fe62ed6f838f6b3abd5c34c7aed0a8711cfc0b916d5919efb6a80bc06fb49"
    sha256 cellar: :any, arm64_sonoma:  "781fe62ed6f838f6b3abd5c34c7aed0a8711cfc0b916d5919efb6a80bc06fb49"
    sha256 cellar: :any, sonoma:        "aa94425dc650a726f84e5c1dda878f0c26e6cd20166824c860cf4e4f43809cf8"
    sha256 cellar: :any, arm64_linux:   "7cebb099cee60a748f58d88029234475162570b31f38ad1861b5c65982cd8b47"
    sha256 cellar: :any, x86_64_linux:  "2aa49a49f47701344c74ed1fdba2ac5c223f64494b46acdb42ec2f27045f36b8"
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
