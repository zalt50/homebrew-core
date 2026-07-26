class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-11.0.1.tgz"
  sha256 "395aa952d0ded4905cd37d4e5b3e5b879943f77d6909c9f8080b111d55a1ff6b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "73812f670b9997df02ea14bd90a5e06c6ac90875eda2b9f0956417539cd6f461"
    sha256 cellar: :any, arm64_sequoia: "73812f670b9997df02ea14bd90a5e06c6ac90875eda2b9f0956417539cd6f461"
    sha256 cellar: :any, arm64_sonoma:  "73812f670b9997df02ea14bd90a5e06c6ac90875eda2b9f0956417539cd6f461"
    sha256 cellar: :any, sonoma:        "15173d97ad5efed68bb3a5ebba6f0baa7340bd969070ef406dd50d33f8b2242e"
    sha256 cellar: :any, arm64_linux:   "94ee929d864e605fb75fa752bb39c08f39f9eca6c9ded6acaab00c07b2684fa6"
    sha256 cellar: :any, x86_64_linux:  "c58e7d2ba244e8a3bdc4868f3ceed5129d2f75ead9d472af29852502569e8e2e"
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
