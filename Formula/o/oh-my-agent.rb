class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-15.0.6.tgz"
  sha256 "8bf6385514928c181c6bdabb09037ceb2336c451fda1eb3ba496f857d97565b8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "cf0197b5c96807749d2a0940b9a23eff3da092ebee259db37a155d89e45000e5"
    sha256 cellar: :any, arm64_tahoe:       "67162f93c105b12085216b98733cae4dfea6c89052a76b78d88bfccd06bdb238"
    sha256 cellar: :any, arm64_sequoia:     "54c83fc1118c099222204398f74cdb49056d2b935fbcc047af6dff35a216e7a2"
    sha256 cellar: :any, arm64_linux:       "ef16cb4fdb0ad212bc6b6dbbb01a69962d437edbb014df9e3121089d9bb8d60e"
    sha256 cellar: :any, x86_64_linux:      "3e9ec9b71cdd76de759e7fe0f1ac90cee39eec8f8c7ce0630ac740128074f2a3"
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

    output = JSON.parse(shell_output("#{bin}/oh-my-agent memory init --json"))
    assert_empty output["updated"]
    assert_path_exists testpath/".agents/state/memories/orchestrator-session.md"
    assert_path_exists testpath/".agents/state/memories/task-board.md"
  end
end
