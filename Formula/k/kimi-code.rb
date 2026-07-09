class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.23.3.tgz"
  sha256 "04b37147af23a38758dfdf93776dc44726a4d13f20a6002ff4471ce20f0d74a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "155ea2590bebbed547d39d67d7648a9ca1ac010c73df0d03193d268c5f58458c"
    sha256 cellar: :any,                 arm64_sequoia: "966b50e99f33aa37029d0276f574c63c0b1bd0ee0e1fc1601bddf7ab143ea70a"
    sha256 cellar: :any,                 arm64_sonoma:  "966b50e99f33aa37029d0276f574c63c0b1bd0ee0e1fc1601bddf7ab143ea70a"
    sha256 cellar: :any,                 sonoma:        "377d9cc68d4658964928a29ac9b343d47b5a532f1969ca7340cdac25eb13d1bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bdf4e95606d12d5db94a2d610f4dcb7b21a787c80668aef6cadceb83e29e0f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cbe3f0caaa43c983530b1f01bc303662809429cfb25d99cdbdb7590ad6437fd"
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
