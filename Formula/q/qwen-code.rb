class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.1.4.tgz"
  sha256 "2c2c98d889ec4af75f5476fa17dc1f269bc3ba31abdd8d07db4b31d7378e0985"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_tahoe:   "f2d1c9ee2beec87dae662ffd1a03aeb70a1e1523eec2e31d264a9e541c1e1538"
    sha256                               arm64_sequoia: "8ef50b75d5bf742cff0234a5da87b7adcc5a0d20814f33c107554e9ff8c1fb8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78a94166d236dbffc007129667dd0037c1d0ab0e23df0b8bf1f544ba8e074f95"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f41c9195333e69ce76b4ec90cab308a0ee368cc20276c768f17e372110fb9a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266c7ebe8f13417e8dbae818c807fb5ceacaf3306f93ad840a05387e79815cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "983fbadb891f1effcee0e3346f695375bb7718bfb47cbc097185e6d5b3412f66"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    rm_r(libexec/"lib/node_modules/@qwen-code/qwen-code/vendor/ripgrep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qwen --version")
    assert_match "No MCP servers configured.", shell_output("#{bin}/qwen mcp list")
  end
end
