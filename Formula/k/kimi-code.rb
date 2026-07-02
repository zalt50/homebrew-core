class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.21.0.tgz"
  sha256 "350b52b0d88bd4be3a37d386e7c8ab3183edb74ad61c0c7fe80203896f859483"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6f7c26170011e22f77fcc5b35ca1c81224b84cbddeed228e7f3a16df7c8ab11"
    sha256 cellar: :any,                 arm64_sequoia: "7577a05a3d032a66a8d0a62beb3925d0f52b4d6e8cc255df4471208f77d9556a"
    sha256 cellar: :any,                 arm64_sonoma:  "7577a05a3d032a66a8d0a62beb3925d0f52b4d6e8cc255df4471208f77d9556a"
    sha256 cellar: :any,                 sonoma:        "385d95c823e774504065fff100e9c1cca30c1da23d3623b7364b2378da9dd2fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36480d8aae0d0f6f390add968f50be6699af5100c9fad9d67483857d7cded57a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbef70183af6071325dc1df2458db793f0e25d55aa6704b8f45e70c2857f925"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]

    node_modules = libexec/"lib/node_modules/@moonshot-ai/kimi-code/node_modules"

    # Remove non-native architecture binaries from `koffi` and `node-pty`
    if OS.mac?
      other_arch = Hardware::CPU.arm? ? "x64" : "arm64"
      rm_r node_modules/"koffi/build/koffi/darwin_#{other_arch}"
      rm_r node_modules/"node-pty/prebuilds/darwin-#{other_arch}"
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
