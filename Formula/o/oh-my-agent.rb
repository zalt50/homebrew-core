class OhMyAgent < Formula
  desc "Portable multi-agent harness for .agents-based skills and workflows"
  homepage "https://firstfluke.com/oh-my-agent/"
  url "https://registry.npmjs.org/oh-my-agent/-/oh-my-agent-10.0.1.tgz"
  sha256 "cd66e3f3e7430cfbca84436a223d384a69fb76dd7f7119c675b22a97ac415db4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c77dab7c313c9a425bb8463db73e5b7b0fc65b6386ad2349acbaf7e69453dbf1"
    sha256 cellar: :any, arm64_sequoia: "991d13f4779cc737c1b81a94ccddf25dcc432bd9269432c20da7b6d8bdb17eb4"
    sha256 cellar: :any, arm64_sonoma:  "991d13f4779cc737c1b81a94ccddf25dcc432bd9269432c20da7b6d8bdb17eb4"
    sha256 cellar: :any, sonoma:        "6ee30485754c900a10e435f677670519bfac254b32b319fcfdb3cc81a0bf8796"
    sha256 cellar: :any, arm64_linux:   "adda819c0b8888bc43d970c790e27351aa89b226309911191889434236e5d037"
    sha256 cellar: :any, x86_64_linux:  "3ca5121ff92a0ade1136aa7147c23b2def8cc362a1e63915863b4adec12897ea"
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
