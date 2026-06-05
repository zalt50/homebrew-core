class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.36.0.tgz"
  sha256 "741beb87dbd93d856f986d197e1f3c4e99e4be8d8d0b56bfc97de78728834548"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a121a048778f93c7687db4fe6188380a752f150298885afd07a954a0de245a53"
    sha256 cellar: :any, arm64_sequoia: "b6380efc482899aeed674ca91f1bc4c96efeb4a525564e7aa7bb86e20d207c05"
    sha256 cellar: :any, arm64_sonoma:  "b6380efc482899aeed674ca91f1bc4c96efeb4a525564e7aa7bb86e20d207c05"
    sha256 cellar: :any, sonoma:        "0e5a3cf90d99d985e505d6190cceadf36452efcc9092d1f47d480b7b841e7f01"
    sha256 cellar: :any, arm64_linux:   "b93225ba3c8128a7e6235ce5670641f0b0c9710c690eedf69627258c05a9260d"
    sha256 cellar: :any, x86_64_linux:  "26fd4cae697ccf608b30d938c2c8f2b391dd3d44a331a5959749df9ab009b892"
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
