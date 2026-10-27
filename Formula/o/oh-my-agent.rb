class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-20.15.0.tgz"
  sha256 "bed7b6ae754c9b11b2f64e823671428015ed90ea37492ff7bc5f883da5bd3dc6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1e2d164ebf81b92ebd15b4010bcd0374503020b9eb8cbf1c11c2d8f231eb9618"
    sha256 cellar: :any, arm64_tahoe:       "a6d1fa9d9d9fe2f26ed3627057248f174914e723c2a97d5927fe3264c77c640c"
    sha256 cellar: :any, arm64_sequoia:     "080a4e3b92319a1f0b5619a23f23c569508672f649396908e4eca3510da08b35"
    sha256 cellar: :any, arm64_linux:       "c94377e351184e75f9e241b842a08e3497864c3c8d5ae4769277908aea29cb8c"
    sha256 cellar: :any, x86_64_linux:      "6445b33b3e730393f374b19dd63d23e6a5f2f03cb4469c4f4a889f4bdfd61897"
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
