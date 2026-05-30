class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.17.1.tgz"
  sha256 "cbea74751219b6bffb7d6b94ad9b42e0158f294893549c22e6ff78bf7ec12537"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5db792380fab998ddcbc029e4653bbba112e360e37a0e6831a1b1a653880a979"
    sha256 cellar: :any, arm64_sequoia: "762b0b4a70db6b36f42bd5629c98f9fe2bb8b3188c1ce66dc102224d24ca9171"
    sha256 cellar: :any, arm64_sonoma:  "762b0b4a70db6b36f42bd5629c98f9fe2bb8b3188c1ce66dc102224d24ca9171"
    sha256 cellar: :any, sonoma:        "c9fd4290c6c53081a3459e3bb3a2acf6399f70fdc03b9196848a5644831e8037"
    sha256 cellar: :any, arm64_linux:   "a57c15a61ac2b6e30c9aea76c59a4d55ea0179a4a92312df147b002b97e21038"
    sha256 cellar: :any, x86_64_linux:  "bdc446e1620b7cd97b5f777530726a0962b0bfdcf80c1a804f0249bd76324afb"
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
