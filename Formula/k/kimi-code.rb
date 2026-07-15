class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.24.0.tgz"
  sha256 "a16dbdc956c7ad081fa7724c4136f7a1aa270a44df13cb11e6225523e558299e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b88f912191e41a356f393d76edfc790a30265938736d8dd2bd0840ebe74ca79"
    sha256 cellar: :any,                 arm64_sequoia: "7b88f912191e41a356f393d76edfc790a30265938736d8dd2bd0840ebe74ca79"
    sha256 cellar: :any,                 arm64_sonoma:  "7b88f912191e41a356f393d76edfc790a30265938736d8dd2bd0840ebe74ca79"
    sha256 cellar: :any,                 sonoma:        "2f9406011db3d65be5f508a8db36bd61a64638ed8ab2a865dcdefb09d574e532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343748fdb428706ad593cbd9220d373103de58db73edb0981d16ec68fdf95972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5ab28aae776dbe256b2e2d3708064c088d622cea634c242effbe718bffaa9f2"
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
