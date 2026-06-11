class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.14.0.tgz"
  sha256 "2e887f8f7b1203e6cb554452044371d0f5f7af8e3ab1653f2c23d62b2f560e2b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9fa2caf1b57d6c84cfd961b939364f043eba0742bce29fd5863bbd55b1fe0ab5"
    sha256 cellar: :any,                 arm64_sequoia: "1398f91194ffd4001691c94d6e74fcc6deab20eec042cbfb3523e0cce99ea4c6"
    sha256 cellar: :any,                 arm64_sonoma:  "1398f91194ffd4001691c94d6e74fcc6deab20eec042cbfb3523e0cce99ea4c6"
    sha256 cellar: :any,                 sonoma:        "627ad1adb603f081f7799277e2ab4ddc9b06e36e4f4537960d6008d6d0c81c3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a96df976d556862b8af472438f6669fd71c707c6ced61ff8dcc116a87465f69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "595cc27052b6d8983a8f62b5a181fd56ca82d0705540facadbc24655d9181a31"
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
