class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.37.2.tgz"
  sha256 "7d5066c07724bd5e2f86b7136d85d3661469dded3a2b4d17c0755771cda7a7cc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21c8ec42b8069afd6a655722d36a785d4c0490ba71088f892816577cb83737d7"
    sha256 cellar: :any,                 arm64_sequoia: "21c8ec42b8069afd6a655722d36a785d4c0490ba71088f892816577cb83737d7"
    sha256 cellar: :any,                 arm64_sonoma:  "21c8ec42b8069afd6a655722d36a785d4c0490ba71088f892816577cb83737d7"
    sha256 cellar: :any,                 sonoma:        "694940ed5de919c005d3944fd4ab164538155770c09a159fd64293bb6e71c590"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a56d8499241840cb9c1f2920f72e0f6a3288ae8e4c27adcbf50ced035b4eb341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a36c83f95d3de177ab92b2537585f56b1bb8c71df0682037d279c899dc6d55e9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    if OS.mac?
      kimi_code_prefix = libexec/"lib/node_modules/@moonshot-ai/kimi-code"
      node_modules = kimi_code_prefix/"node_modules"

      # Remove non-native architecture binaries from `node-pty` and `native`
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
      rm_r kimi_code_prefix/"native/darwin/prebuilds/darwin-#{other_arch}"

      # Strip universal binary to native architecture for `clipboard`
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
