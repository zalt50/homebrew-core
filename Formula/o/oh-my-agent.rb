class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-14.12.2.tgz"
  sha256 "b229fafbb098686fbad9b763c1232ff92486181b10e932c33325191cda5c2012"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0ba42ffe96d7eb4714c03b2ef5b24d42c223ed0f6630cdb64919c517923db97a"
    sha256 cellar: :any, arm64_tahoe:       "e3a8ff00f595935668db5ebe0d138fa0b36e347daceb982753c8c580aa4c2918"
    sha256 cellar: :any, arm64_sequoia:     "d18106b82e9c2185e5ef98db0e55fa95571c655639876fd6fcb045e9d56d7d0a"
    sha256 cellar: :any, arm64_linux:       "2ed9be65fc9cf4fd52a6fc210cd8847197250302c15322b61c0b48f260796227"
    sha256 cellar: :any, x86_64_linux:      "fa1b7690afa17f7c1aa7199f14c7becc2e6a87cbdd3c6f676e221d4bcd99cdc7"
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
