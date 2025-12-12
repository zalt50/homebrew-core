class QwenCode < Formula
  desc "AI-powered command-line workflow tool for developers"
  homepage "https://github.com/QwenLM/qwen-code"
  url "https://registry.npmjs.org/@qwen-code/qwen-code/-/qwen-code-0.4.1.tgz"
  sha256 "c80b603052ef8377cc84b7cd5d8e6983e6e434094c553629ee0b4747afcc2ba7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05c3274ad8f4e0ad3ff15a4d828470af3586e554c81646ecad602368456a6dd3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05c3274ad8f4e0ad3ff15a4d828470af3586e554c81646ecad602368456a6dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c3274ad8f4e0ad3ff15a4d828470af3586e554c81646ecad602368456a6dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b421297d6992dfa66b886ea1e7ec53897577aaad6c566a9b8c5f1db9f243943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e0b3062fae7a98f6ccfa160a60207d531d2aa6f04766c93bb973f5f9229303d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d18a4b7bf8744f173402e093444d406418a651392a2934d7363959ec05b1c67"
  end

  depends_on "node"
  depends_on "ripgrep"

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
