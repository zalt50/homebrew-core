class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.30.0.tgz"
  sha256 "64787fc94e9b97fda75f5c96ea5c58bf7e18dba3195f6ac17bd426bc2b501142"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e6ab03b523afc70ed72e3f20b3ce9f30f31ca140bc88fc565a6ab55818237709"
    sha256 cellar: :any, arm64_sequoia: "e389ac79f8108c50470c421016df5243c22655bc18a1b3bc7fe803cecb9d1958"
    sha256 cellar: :any, arm64_sonoma:  "e389ac79f8108c50470c421016df5243c22655bc18a1b3bc7fe803cecb9d1958"
    sha256 cellar: :any, sonoma:        "c5b6bf8fee533959fcf774fdba9a2e16db38f46759e1773eacfe8271f96feb5e"
    sha256 cellar: :any, arm64_linux:   "825d8a5d0e953b16bed339e0baa25b5c8a0e0615e73d6b7eac5bb0158b265fc0"
    sha256 cellar: :any, x86_64_linux:  "0673d9a30a94bd1d648c9129d7ad742ecfed14ace269be218ea1ea55e697e38c"
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
