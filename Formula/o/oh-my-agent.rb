class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.1.tgz"
  sha256 "a8cc3d422fe0a6a965f05ffe59ad978aa1c9e467775c2ab42b2bfac2f43d35f3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "07b0fca5f8ec4f3cf3465a10d6983e1b527d6644d515b20c53dd0b76b7576f86"
    sha256 cellar: :any, arm64_sequoia: "93d1ce1757795c793cc53a4e7585c35e1223fc7b997d18e565f39a05cb4b8657"
    sha256 cellar: :any, arm64_sonoma:  "93d1ce1757795c793cc53a4e7585c35e1223fc7b997d18e565f39a05cb4b8657"
    sha256 cellar: :any, sonoma:        "81866c07cfeccbfbedfb5df9ca48d0bb39cb70aaf31ef0d7c48707f13af20e0a"
    sha256 cellar: :any, arm64_linux:   "976a3c9f684611e8c19d4da6b1ea8de963df5ff6630a8f3d224ae943709335d0"
    sha256 cellar: :any, x86_64_linux:  "ad0bff736fd107b782be58c7fd5b2b7815b0c4ef5e46359750da79ceae896dc5"
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
