class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.21.3.tgz"
  sha256 "79401e35fbb8e0f1a76bfe5a85a262709490090dbeb8f3c3466198db81318df2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a227de4d447c2a9fd74c6babeeb0febf0d91165606adb00996a7064c865da64"
    sha256 cellar: :any, arm64_sequoia: "8a227de4d447c2a9fd74c6babeeb0febf0d91165606adb00996a7064c865da64"
    sha256 cellar: :any, arm64_sonoma:  "8a227de4d447c2a9fd74c6babeeb0febf0d91165606adb00996a7064c865da64"
    sha256 cellar: :any, sonoma:        "9758ce7fda1dd5b5b6ea6d0a8f2af6771b7ddeef0bfbddf140034a6008678ba0"
    sha256 cellar: :any, arm64_linux:   "8446959a8abc88657d5f2093b4d1dd42ed3fd5ba02d80e0a226179484e223ab7"
    sha256 cellar: :any, x86_64_linux:  "c93990ebb9369212cea6939038a7fb5aa30ad9b65d753342c5df4a939e5a919e"
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
