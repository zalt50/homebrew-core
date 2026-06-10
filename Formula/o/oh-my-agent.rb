class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.49.1.tgz"
  sha256 "23c5aeff8eb580a1183284885701efef9ab6fae35f1a8b5c7a3f6394f9f3babf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "126986db7242188225c13864a7050232a875263695884872e033f3e3aedeb9e2"
    sha256 cellar: :any, arm64_sequoia: "85c6bf06b95b7599d16886459fd3c0847494373e58cea93d7e22d73fe1577e8e"
    sha256 cellar: :any, arm64_sonoma:  "85c6bf06b95b7599d16886459fd3c0847494373e58cea93d7e22d73fe1577e8e"
    sha256 cellar: :any, sonoma:        "7fffba6e21ee1cd4f96609b03e3d80a42ac2f11d649648cfa8519d0f1d7009d7"
    sha256 cellar: :any, arm64_linux:   "3f1fc0b6137b7f61d2f91b1dddf2d76359151223cc3668afe3ef5496d6136653"
    sha256 cellar: :any, x86_64_linux:  "57451f705d5758f5f887883112bc588600ef3a13ec2f708bfefb729cb71cf59f"
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
