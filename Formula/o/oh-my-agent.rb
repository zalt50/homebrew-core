class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.15.0.tgz"
  sha256 "29fba8f57ba674c7e1ea882a0bdd27b605f14c8fc94312509fa4a228cd709687"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9dadff809fd83304af4745192595e680c70afec38ac9160f742502d8a6f7c205"
    sha256 cellar: :any, arm64_sequoia: "16e0412ccb4fd02ecc93add0f5a1fbcec50f3f90c91e5c0a52f9c89b27ba3634"
    sha256 cellar: :any, arm64_sonoma:  "16e0412ccb4fd02ecc93add0f5a1fbcec50f3f90c91e5c0a52f9c89b27ba3634"
    sha256 cellar: :any, sonoma:        "d473419ee984c26a8261e0d642c7831bbb3533052c573c58c2f570dbfb7ff8f2"
    sha256 cellar: :any, arm64_linux:   "e2fdb78aab94856f2f70a6d6bd9906a716fbf07acb44c4bc9c56f82817fc6e4a"
    sha256 cellar: :any, x86_64_linux:  "8c4674cf14629e47ec0009ed40a8de417f7a614e83e6bf505c3a21f0b61c24f1"
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
