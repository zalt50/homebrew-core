class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.22.1.tgz"
  sha256 "60d7bbe54d7430cb61353f183208bd4936f4d9ad0345efd490b9417a6855c794"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7aecf4c8db79b935a44ee227be9b88f1b6a3c36b5baa1108d062a243b675444c"
    sha256 cellar: :any,                 arm64_sequoia: "4d619bab9bb05f963a85c9decc7fc3ee1b471664794cd57795061a2835258af1"
    sha256 cellar: :any,                 arm64_sonoma:  "4d619bab9bb05f963a85c9decc7fc3ee1b471664794cd57795061a2835258af1"
    sha256 cellar: :any,                 sonoma:        "4747d8d9fd25977cfb347198fe7fa8d9a00819281c5e11632641da83f87876e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7d81773573a1d3c656bc8a693a3ff9b8e9188060733d31f6bd76f1e2e64e887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4581d5f3e650e7f8556ea99bfd4a61160fc2e5f636712e248a575a1eb93313f9"
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
