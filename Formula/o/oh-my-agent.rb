class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.2.2.tgz"
  sha256 "802985f36f86ada3d1dcdef7315b6e462386e409768f480b7bc6d7b706b8d446"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "beea2eab0607044cdc9a8b337f1856753c76e6418eea58bd759aa0c34473c868"
    sha256 cellar: :any, arm64_sequoia: "beea2eab0607044cdc9a8b337f1856753c76e6418eea58bd759aa0c34473c868"
    sha256 cellar: :any, arm64_sonoma:  "beea2eab0607044cdc9a8b337f1856753c76e6418eea58bd759aa0c34473c868"
    sha256 cellar: :any, sonoma:        "76f90d886d14cbd3dae6f12cbe0e3511cc0310d37b778f06a3470d6133cb6aba"
    sha256 cellar: :any, arm64_linux:   "2780d609c00e545f7ee50b04547fa41d52b1e72cd7e5b812974b16c541b544ca"
    sha256 cellar: :any, x86_64_linux:  "1c3e1bcafc2d146b2aaa7e7944d0d86f6c435196b78306f6515f2019d3ecc849"
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
