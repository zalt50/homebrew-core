class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.41.0.tgz"
  sha256 "c259f91bcfe2606c6e162dd3531ab5a56a8f41c919399c470eff9cb9013cd5ba"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2b6c6b077c7b102724965ec261fd9cd5a37227095395733dd2a26e8c498315e0"
    sha256 cellar: :any, arm64_sequoia: "696917f493f5ac056e337e3b93dbeccac7e243740e47c9654878fa9cbed0748b"
    sha256 cellar: :any, arm64_sonoma:  "696917f493f5ac056e337e3b93dbeccac7e243740e47c9654878fa9cbed0748b"
    sha256 cellar: :any, sonoma:        "b6c9a2a8196f3970c9a2a15865d555a573a5cdaa08968042ca2530d4d1f5a4d2"
    sha256 cellar: :any, arm64_linux:   "7148416ace264ee456916045538dc1f05196d4ee4d9a839dd1783a8022209478"
    sha256 cellar: :any, x86_64_linux:  "9532de86a9d59e4403876ebead488087f3381164c5ae90478cbffda2ac67ee04"
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
