class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://github.com/first-fluke/oh-my-agent"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-8.51.0.tgz"
  sha256 "1c5c1d3c3c68cb84ab6a10a47fd6ffb3bdd08472dfd6ad727fa9b1412a6f5d51"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a198d2591ad52d8de7aec439bfae45d43592d50fa20a05592995ce72f5c336c"
    sha256 cellar: :any, arm64_sequoia: "0c7b922a3a053551352ee368b7e9b0e10ee9b9494e95b9706508010700b92fcf"
    sha256 cellar: :any, arm64_sonoma:  "0c7b922a3a053551352ee368b7e9b0e10ee9b9494e95b9706508010700b92fcf"
    sha256 cellar: :any, sonoma:        "7c396a7f23af824a712d2ef767675d9af1d201774d2d5c45db73bfc72d7ffa05"
    sha256 cellar: :any, arm64_linux:   "3574620501b18d602e054731630f743ffadc0ee2a9b0b1e9c9a50a21f0bbf56d"
    sha256 cellar: :any, x86_64_linux:  "f3e7bd6c54c11f98a06a02b862347e7bbe63b4c8c57163cc02195649da292aaf"
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
