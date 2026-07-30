class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.2.3.tgz"
  sha256 "7e62a59b1060ebddaf25b64a8cd700c60337874a4da632212fcbe103305c3f01"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "46969fd0376fa6d10bde526ac70678ac3fac37cb668f0b6796b4c241e7c2f202"
    sha256 cellar: :any, arm64_sequoia: "46969fd0376fa6d10bde526ac70678ac3fac37cb668f0b6796b4c241e7c2f202"
    sha256 cellar: :any, arm64_sonoma:  "46969fd0376fa6d10bde526ac70678ac3fac37cb668f0b6796b4c241e7c2f202"
    sha256 cellar: :any, sonoma:        "d679944546b871e3843ef7f522301744dc2b217eba40e98610899825c90b3e4d"
    sha256 cellar: :any, arm64_linux:   "a8c8a600cfc8a38114e7729ad8a676ff5c6865d4bcc7152eeb10d9434a248ef4"
    sha256 cellar: :any, x86_64_linux:  "38b43796bf91ae25e91f71d0bb2ae0dfec4d114f55ff650df22770d72891c99a"
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
