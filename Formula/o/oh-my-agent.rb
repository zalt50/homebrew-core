class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.10.0.tgz"
  sha256 "6c3c3004bd03813039eb5b54e33e1b288100773910fe1e0e3962f3d346edcb0b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1dd33d5ddacbd588edee64015206c55420ce62fc861f586327b9c67beeb99579"
    sha256 cellar: :any, arm64_sequoia: "d4ed4f3dbeda70d277d70a4a583f05642978cf519ccc217ea7aa8df40add57f0"
    sha256 cellar: :any, arm64_sonoma:  "d4ed4f3dbeda70d277d70a4a583f05642978cf519ccc217ea7aa8df40add57f0"
    sha256 cellar: :any, sonoma:        "93839878a3932029c9b05e21247a3368ad42a4745b2ca14726e96817b2c5be56"
    sha256 cellar: :any, arm64_linux:   "29962086014623d4b05b34408d4e76223650aacd27db11ad2c947131f352e937"
    sha256 cellar: :any, x86_64_linux:  "a84583d43252ad204e7d9bf9ff8cbec6f96eb3d24daec7aea30ec761d6f03024"
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
