class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.47.0.tgz"
  sha256 "c061260259f6366c67bdb303f1e0c724bed6c7125d7dc7e0ff1dc54e6bc8e91f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68c9cc54191b3868349e836d83522fd61461cb99c25b33f29a6add852bfd6f92"
    sha256 cellar: :any, arm64_sequoia: "7475749834ffcc2f6e2ebb81ed0b8fbfee8dbb05953f2c72f9559bdcd41c72fa"
    sha256 cellar: :any, arm64_sonoma:  "7475749834ffcc2f6e2ebb81ed0b8fbfee8dbb05953f2c72f9559bdcd41c72fa"
    sha256 cellar: :any, sonoma:        "d1f8a03dbddb37542e630d46feb3cca76ebd8cb41c3623c51feecac6338b4851"
    sha256 cellar: :any, arm64_linux:   "df3e63f6d16655208505dcfc5302552029a3b0560ea78e643475b16000b8d69a"
    sha256 cellar: :any, x86_64_linux:  "5d838f99dcabd49dad877a7818faffd459ce94bd8228b0202f9a3c76be63949d"
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
