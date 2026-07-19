class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.21.3.tgz"
  sha256 "79401e35fbb8e0f1a76bfe5a85a262709490090dbeb8f3c3466198db81318df2"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd1ba309594a616f4dca838d6b13fcddc873e1e4cbb4b64c32cf48b7a80d405a"
    sha256 cellar: :any, arm64_sequoia: "dd1ba309594a616f4dca838d6b13fcddc873e1e4cbb4b64c32cf48b7a80d405a"
    sha256 cellar: :any, arm64_sonoma:  "dd1ba309594a616f4dca838d6b13fcddc873e1e4cbb4b64c32cf48b7a80d405a"
    sha256 cellar: :any, sonoma:        "61f2a8a2ea3d9e060aee9c351d95162285706d7c394cac53301af37ddb0817c0"
    sha256 cellar: :any, arm64_linux:   "ab274fede1678f8e723e23ccb61dd51e74aaf8535379d44c6463ddc681ad9d76"
    sha256 cellar: :any, x86_64_linux:  "697bae9c104ece1335bc151d33fb18893d64c4a93faa6d86dce7a4a4a99ae198"
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
