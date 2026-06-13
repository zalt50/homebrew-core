class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.14.1.tgz"
  sha256 "5f618d4fa07e6642371e43de042d1b2cecd0359134643141f0663d7952572ffb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1513ad7cab2b45eddcd9bbc74f121486551036aef61500bd89125647f8c83ca9"
    sha256 cellar: :any,                 arm64_sequoia: "dbd13a12c188ee2235e4a4f904e8455ebcc2d4321f5230464085ef641e210c74"
    sha256 cellar: :any,                 arm64_sonoma:  "dbd13a12c188ee2235e4a4f904e8455ebcc2d4321f5230464085ef641e210c74"
    sha256 cellar: :any,                 sonoma:        "a7403d1c7c4c992fd5f7c640dbe5c4f961ccc78d3bd450d32288994ac64dfd94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369584b31cecf13b155746b6d5427fc7a8240ec55f547bac3771f58156d87380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae42aefe18e9dd40e8a7a115d697184b878116d244130a69624a89d7c9b7e8d"
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
