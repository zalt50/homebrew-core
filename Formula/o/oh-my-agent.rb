class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-9.6.0.tgz"
  sha256 "2bdcfa8adb433bd587b9dc74ca1315fba82bccb714a590472fbbb01eb4d98e9d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "db5307e3114f2b582a163a795cfba86c4f1eb7a65f4f8d53111698f9e087d6b7"
    sha256 cellar: :any, arm64_sequoia: "c06f0671f11c8db5134aa33151eaf53d04879e3afdc87f182d9a70d2b5b8eb1b"
    sha256 cellar: :any, arm64_sonoma:  "c06f0671f11c8db5134aa33151eaf53d04879e3afdc87f182d9a70d2b5b8eb1b"
    sha256 cellar: :any, sonoma:        "3a12d09e4d9d0e0124e9953c5e28e9322f53262dbd36c293b60ea18cdcd00da3"
    sha256 cellar: :any, arm64_linux:   "5b061c8c44f011da1c440c296129ce837af4fd871e18185915d3d4288e69bc97"
    sha256 cellar: :any, x86_64_linux:  "b7d00a62006cfa74dc74b1671f50c2926b16bfccce9106458cd155db436975f3"
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
