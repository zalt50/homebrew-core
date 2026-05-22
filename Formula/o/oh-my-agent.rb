class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.5.0.tgz"
  sha256 "5f691291801b8de8a2ee06de82a75883e48fe48320af0e8b299625f051bec488"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ab76927c5e8f4f00b11ba116e412c501dd4094ef126c8d724f132a0bb343395"
    sha256 cellar: :any,                 arm64_sequoia: "18ef17cd4b7aebaa2f5fe00c73c34c3b13b14e07d2de2c41afd2734ddd30ee92"
    sha256 cellar: :any,                 arm64_sonoma:  "18ef17cd4b7aebaa2f5fe00c73c34c3b13b14e07d2de2c41afd2734ddd30ee92"
    sha256 cellar: :any,                 sonoma:        "44264682921bac67d661267a4a3c6c555c504d9d605adf3d48c407e63da27847"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4a0355c08b930933ffdeb41c77785623de1ef922a94e773eda6ccd89a1910a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a511f8a314a78cd8df845f360d627d600ff24dd473a8fc564edbefe8d6696e3"
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
