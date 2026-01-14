class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.7.1.tgz"
  sha256 "71155f6e9fbe9285ace10639d22bb60d8bad4cfa4f40c1530145522dea0225a3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d96dde28f55b35f2e3682e07a8a72f45a32977b6dd51e519c32cba31ccb6f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d96dde28f55b35f2e3682e07a8a72f45a32977b6dd51e519c32cba31ccb6f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d96dde28f55b35f2e3682e07a8a72f45a32977b6dd51e519c32cba31ccb6f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec77bd7ffba6d9a46a30cd13b879b40338da9404f535f0e14bb59d2bef5d03fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "436d995a2a48e1318e56aaa4ee2f731620ef0aef7e057743896d546b1dfa7dfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88d7fec451b5c2aabf8ae5ebe73f78d7388a4de173dee980b0bb38a4a909a47a"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    qwen_code = libexec/"lib/node_modules/@qwen-code/qwen-code"

    # Remove incompatible pre-built binaries
    rm_r(qwen_code/"vendor/ripgrep")

    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    (qwen_code/"node_modules/node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
