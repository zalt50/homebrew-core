class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.5.0.tgz"
  sha256 "8a7ccd96a06c0b8e9958554e86713db1e5b8738abce5e3fe3a9b12d7d516d0bc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6eb634f5630db2368ccb1af858bc88d9845c8aecf0df1375796752708df5fcf3"
    sha256 cellar: :any, arm64_sequoia: "4c98c36a6e91bd0bfd5768374400d4977202009281cadbb4be2a522180f5722c"
    sha256 cellar: :any, arm64_sonoma:  "9ff1be98dd2909ed440fe57a8dd8f998b1f2adc0d6d46a341cb43838485b4161"
    sha256 cellar: :any, sonoma:        "49c804fe79fa04daf15f19660e260838d863e7fc0e32947e8fd026aac60d7e56"
    sha256 cellar: :any, arm64_linux:   "3e00e6450a742b3340a4c948a2970d1a69a7e6e9d976ee9856dca9dfd8152693"
    sha256 cellar: :any, x86_64_linux:  "cd421def1f2ea0ff7474fa5694e2f49dee9a678617450895528f3aec544004d5"
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
