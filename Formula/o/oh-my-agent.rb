class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.41.2.tgz"
  sha256 "cac0a3bd87a1b0e6729d7ae8440d2495939f7aea4721b1b038659e3af1e6621a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38dd1a11caabd7237a80d8312a9943e2c726501b227237553c8ba27c748ba9f4"
    sha256 cellar: :any, arm64_sequoia: "9f686b2725530817b98bb322403b1bd5ac9992dd51f7f06e38872f16da3454b5"
    sha256 cellar: :any, arm64_sonoma:  "9f686b2725530817b98bb322403b1bd5ac9992dd51f7f06e38872f16da3454b5"
    sha256 cellar: :any, sonoma:        "d3c7caea164320a17aedd0ffbd26dba65b23176fd129d6725400cbb643846d83"
    sha256 cellar: :any, arm64_linux:   "fb4b9f7e21470046e85b6e01db968f0d98b1baa9ccae701f529728c278b5d349"
    sha256 cellar: :any, x86_64_linux:  "eb6cd695b376f9507fa3229adfc664859f0a9a4c9808185d151405581516ba29"
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
