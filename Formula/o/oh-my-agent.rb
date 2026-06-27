class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.6.0.tgz"
  sha256 "a9a3afe5bb9232d7c284087dc66bd100239cf99e3ad000d0e2859fda8fde44af"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0a01eb7b6b7f62c4e135bc1e14679f3b5b6d3c20958f6d6a2ef1a0bc16bb6a48"
    sha256 cellar: :any, arm64_sequoia: "db287f9df0832a2f649c0fc4f184145107af6da0e5fe633cb4ea4d9f55d8dd8e"
    sha256 cellar: :any, arm64_sonoma:  "db287f9df0832a2f649c0fc4f184145107af6da0e5fe633cb4ea4d9f55d8dd8e"
    sha256 cellar: :any, sonoma:        "32dd53f7025c6b43e63bf00b754a0a0941561fa8dd889e22fa305a4ebbe0ad78"
    sha256 cellar: :any, arm64_linux:   "f3e02f2a8f561618bda2582f0047fa4b4ce5975eddecfb6450a252f4f9db287d"
    sha256 cellar: :any, x86_64_linux:  "755a50823bf6267ac057a0e90df1c0ca269ae953177c4d105fca1c0582ada3bf"
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
