class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.51.0.tgz"
  sha256 "1c5c1d3c3c68cb84ab6a10a47fd6ffb3bdd08472dfd6ad727fa9b1412a6f5d51"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c3820bb575fe423d988a16bdce0a416c1badf85ce951fa010458541d9f9cdb84"
    sha256 cellar: :any, arm64_sequoia: "0705cb6e8b7fa1a56d4c2e92586d3fd5e5d09b75cbb2b3a830edabe36c138202"
    sha256 cellar: :any, arm64_sonoma:  "0705cb6e8b7fa1a56d4c2e92586d3fd5e5d09b75cbb2b3a830edabe36c138202"
    sha256 cellar: :any, sonoma:        "345170a0fa25f3d83b2b2aef956409518a2375b4f4fac957d8ffe6a2c55cedb7"
    sha256 cellar: :any, arm64_linux:   "d0d02566b3149b653f8f2786b3f14bf896998f82245c37499c9209a823bc9341"
    sha256 cellar: :any, x86_64_linux:  "914dfa2944de9c70587f3f6f699c89e2b5682bd8341835fa80a24e5d13e937b6"
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
