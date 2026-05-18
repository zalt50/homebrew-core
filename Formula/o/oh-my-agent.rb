class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.20.0.tgz"
  sha256 "9014bee59433d492fc997cbbca97ea8975575b8b3431e2c15fbf4a49c64f7f8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8c255413d90711c57376e2b59cd59b67920e7070bf231e0cb06eead7c6928fb"
    sha256 cellar: :any,                 arm64_sequoia: "f6e3b1f0d1e32a641f81ef062874f193139a384c9efa168bfebb103237b54a92"
    sha256 cellar: :any,                 arm64_sonoma:  "f6e3b1f0d1e32a641f81ef062874f193139a384c9efa168bfebb103237b54a92"
    sha256 cellar: :any,                 sonoma:        "b78c1d09fb2acae303504fc3042ace6bbbb00f2b5a0feab8ff2126494b0e85f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2d57365183982b813caaab663bbc75344721970c2326f83d06a37979fb34c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6363b054f7fdb198aaeaf94b6d351ea0db1a5b2eddeffa008a882150986cf1b"
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
