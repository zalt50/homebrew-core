class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.31.0.tgz"
  sha256 "6bfe8edc2d3eb7080114d85f763b345ef4e611c384470e347414ce05201a825d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "11bdecd355b90ef716504d956874f682e07345e44834ed0e3fd7090790ed9993"
    sha256 cellar: :any, arm64_sequoia: "0d544e82992d9355b8e57b399d743eda2e43aee762beaaca8ae85c4ea5ced95b"
    sha256 cellar: :any, arm64_sonoma:  "0d544e82992d9355b8e57b399d743eda2e43aee762beaaca8ae85c4ea5ced95b"
    sha256 cellar: :any, sonoma:        "fe02e4ba6403a51ba9a163a383d972174800bee3c700f58145b802281231404f"
    sha256 cellar: :any, arm64_linux:   "a58e0a286dc85677fa336d58f61b499cd76e619e4fa10a593f57fe1c4337afc0"
    sha256 cellar: :any, x86_64_linux:  "d43be0897e95e951c26c45cad101709965b094c3e9d79886bad2cc5d6a318421"
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
