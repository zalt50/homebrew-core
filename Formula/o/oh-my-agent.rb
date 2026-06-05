class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.39.0.tgz"
  sha256 "2a5fec24bb74c09644032a0bbba5f3c89b6bb9fdfc0e77ab2eac678a21e49334"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d278259121dae7abe5a15e9c35ac94a4a88cf1db383bee4330090e03f25baaa2"
    sha256 cellar: :any, arm64_sequoia: "00468e69b5ece80a5016ba48ebd872cb2bb816050075c00df52221ec0148be3a"
    sha256 cellar: :any, arm64_sonoma:  "00468e69b5ece80a5016ba48ebd872cb2bb816050075c00df52221ec0148be3a"
    sha256 cellar: :any, sonoma:        "495317dedbe0cf48d3d9067aba5c213b29604309552db815a8fa486ace5c8f9c"
    sha256 cellar: :any, arm64_linux:   "2bf6745a42d98b0a68940fb84d62c9256d3dbbd2ec413e180c49d4868cefacf6"
    sha256 cellar: :any, x86_64_linux:  "18ef6354f735c85dc70bd4bb88c2702b50a75fbcab545fa82fd2dc611691a760"
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
