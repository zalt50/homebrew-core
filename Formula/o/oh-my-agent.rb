class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.2.0.tgz"
  sha256 "86b8f0b1bb3c421875cfdc1f90d272d5a294839ec2ae7bf398e2e57231696201"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3af394f4618d2b68bbca03881b44cff7755a177ca2fcd3b502c5077c6dea8c3"
    sha256 cellar: :any, arm64_sequoia: "16d7630dc3ee02cc143e1e65b88fc42d85ccb2ad66f70ab631fbb5ba38d9ed43"
    sha256 cellar: :any, arm64_sonoma:  "16d7630dc3ee02cc143e1e65b88fc42d85ccb2ad66f70ab631fbb5ba38d9ed43"
    sha256 cellar: :any, sonoma:        "240a1afa810575622826f56f95fc393f5115f669fd76464e610979d7185f2782"
    sha256 cellar: :any, arm64_linux:   "445774b4170fbd579dd96b8bdacb0a8f11a8ee87551c45068e5aab34125fbc15"
    sha256 cellar: :any, x86_64_linux:  "b2bdef891a7cd4e2eca1f662656d58a6e14f340976a6027a10243b82f08493de"
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
