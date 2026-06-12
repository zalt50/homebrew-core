class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.52.9.tgz"
  sha256 "47bf5d26bc048a93c868f414ffb9b4b86af56726a7d1095e0bba7dce899472df"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e3f68bda0326220069d2ef7b79f27cdcaad130a63bf086794f360794d4bbf6f0"
    sha256 cellar: :any, arm64_sequoia: "9862fc25bd20005d168d11645eaca53e001d4664e3c67be1a21080bba01c5b14"
    sha256 cellar: :any, arm64_sonoma:  "9862fc25bd20005d168d11645eaca53e001d4664e3c67be1a21080bba01c5b14"
    sha256 cellar: :any, sonoma:        "92f43d9073a9732352dc47d419ec744e63cda5245baa255e60a9fd809b1df449"
    sha256 cellar: :any, arm64_linux:   "740dc2d6aba79fa8b9d0bda3a4770a187f9fbb84f35e7095141f4d452a33c0a9"
    sha256 cellar: :any, x86_64_linux:  "d4171621fcd91b692fa2085eb96d620d263ae48483b030d123a3f32c0917c5d9"
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
