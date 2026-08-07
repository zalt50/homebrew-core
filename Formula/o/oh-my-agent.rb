class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.9.0.tgz"
  sha256 "60207cdb63f1a35f654d95ed4fda030d48ad8f86c897182f3b11f0139077e734"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f98be3d0210b00b4845c61e50b49d4b6b7f82275ccc9253df68300ef4805278a"
    sha256 cellar: :any, arm64_sequoia: "b2c070b5ed7693ad7f97e64b9cc1a343499f2a0612e0376bdd0aae4aed102058"
    sha256 cellar: :any, arm64_sonoma:  "a714709f4c26e11195acb535bb5e59b9675ee30ce93342ff10257742c3fe27dd"
    sha256 cellar: :any, sonoma:        "18c94e265b1e00ba5bf97feab5a8a2acdb8faf1b7c4feab4ef8a43f2c062bf2f"
    sha256 cellar: :any, arm64_linux:   "84e44baa59737fc80f3ad1d503d2e86b93154482ba403e4c199410803aa0e415"
    sha256 cellar: :any, x86_64_linux:  "41e47c571c01db17621fffa6b4327c715bf215ef0a634de0b9308d3cba57c474"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    node_modules = libexec/"lib/node_modules/oh-my-agent/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-path`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    rm_r(node_modules.glob("better-sqlite3/prebuilds/*"))
    cd(node_modules/"better-sqlite3") { system "npm", "run", "build-release" }

    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-agent --version")

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory:init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
