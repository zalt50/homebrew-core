class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.26.0.tgz"
  sha256 "6eba3f8d1627fd7f77b0aff69606762c1ffd24f73d9e3d042085621d8fca0c21"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fcb57e35524909a479809d5ae6ba56cd38c1368e82b49414b88663db49f1d6d2"
    sha256 cellar: :any, arm64_sequoia: "c586c51b256f368602c22e34bd3b4b773d9c7417ead3e98441fec722927169a4"
    sha256 cellar: :any, arm64_sonoma:  "c586c51b256f368602c22e34bd3b4b773d9c7417ead3e98441fec722927169a4"
    sha256 cellar: :any, sonoma:        "ca0975646228679dee0c354c59b84882f500b245db3e7384a6637be97add3b21"
    sha256 cellar: :any, arm64_linux:   "87af01e3866d8ed15a15918a6d8a6129366ee318fe1a92a4fbdc98521b6593b1"
    sha256 cellar: :any, x86_64_linux:  "a831b58e0eee805b22470f4785512719b4f868b8d6e28c4321e19472258b7a21"
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
