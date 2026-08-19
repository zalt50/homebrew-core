class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.37.0.tgz"
  sha256 "94c43dbded84243a5c156f90adba38720da36e6c2220212640a4c15968e2ef46"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cdebb77923448692c288ceaa32ff38dbe85891d8d71564f9d2b554ea20f128b"
    sha256 cellar: :any,                 arm64_sequoia: "9cdebb77923448692c288ceaa32ff38dbe85891d8d71564f9d2b554ea20f128b"
    sha256 cellar: :any,                 arm64_sonoma:  "9cdebb77923448692c288ceaa32ff38dbe85891d8d71564f9d2b554ea20f128b"
    sha256 cellar: :any,                 sonoma:        "e88f9a36dbe80630602ee3c373f40bb3039e573fd15073c6f2847ba8b47108ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b90fc019fddcd745054e06ddf25c14bbe1a7949bd94e1343f307c3b63e778542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "775a83d784c21a6188cb26dcac4147d5581f8282f2604a64b30d7c4757017e66"
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
