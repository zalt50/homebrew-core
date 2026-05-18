class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-7.15.0.tgz"
  sha256 "6a4e697b09e4f68d2369eb3604b6f418318afb2f3847b2d32a18713fb5dd6225"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b28435623e3cb13c6e202fa7df35d5d48393b759c97ebd696195bef4045a914d"
    sha256 cellar: :any,                 arm64_sequoia: "1f79217729f5152a14ea8856af921eb25a07862a097a2e3392cca84982580c8c"
    sha256 cellar: :any,                 arm64_sonoma:  "1f79217729f5152a14ea8856af921eb25a07862a097a2e3392cca84982580c8c"
    sha256 cellar: :any,                 sonoma:        "45553ac5f0fab7939e5395cdd07d50889b56a9fb54e5cb2c9e8fea7492c3043a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df3464e728e8a38f17216880a37a4b6b8b816fda7efbf5b16171ba9ca72f1df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a51d5432764941d25b10e120de962940a0a96f67c5aaecbd8860a42c978038"
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
