class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.12.0.tgz"
  sha256 "6e5c566971497360edb2fa8c4a65e4a3c67d41dd51a855f0dea033d9baf4c2ab"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9975f4ebc4b7ccd8b7a24d7f8e7226377ac1dff66507062d8e4233a127548cfd"
    sha256 cellar: :any,                 arm64_sequoia: "aa8782e7141ccc2f08d5ccac4b274def223c178c605f5cfed89302867a44380e"
    sha256 cellar: :any,                 arm64_sonoma:  "aa8782e7141ccc2f08d5ccac4b274def223c178c605f5cfed89302867a44380e"
    sha256 cellar: :any,                 sonoma:        "12b722ee6ff24c5233b22a55435644a86818e1c8f15bd95ea849ecc44e5a073a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d4942d2605e7df20624fdf485b9325b1e23ad9015096c4754227598a78434a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "291fa53116ade3292b33b66cd5e4e846a9b022af97638177318b42e5a2856597"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi`
    if OS.mac?
      if Hardware::CPU.arm?
        rm_r node_modules/"koffi/build/koffi/darwin_x64"
      elsif Hardware::CPU.intel?
        rm_r node_modules/"koffi/build/koffi/darwin_arm64"
      end
    elsif OS.linux?
      # koffi requires libc++ which is not available in Homebrew Linux;
      # remove all prebuilt native binaries to avoid audit/linkage failures
      rm_r node_modules/"koffi/build"
    end

    # Strip universal binary to native architecture for `clipboard`
    if OS.mac?
      deuniversalize_machos "#{node_modules}/@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kimi --version")
    assert_match "No providers configured", shell_output("#{bin}/kimi provider list")
    assert_match "No model configured", shell_output("#{bin}/kimi --prompt hello 2>&1", 1)
  end
end
