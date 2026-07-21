class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.28.1.tgz"
  sha256 "aafbea0441eef5dae3f752accd51713341039fd1c117d166835609e641e094b9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3317b7995b649ce76f5925339bbbce3c2073bec6da69b52a64903998c8ecf71c"
    sha256 cellar: :any,                 arm64_sequoia: "3317b7995b649ce76f5925339bbbce3c2073bec6da69b52a64903998c8ecf71c"
    sha256 cellar: :any,                 arm64_sonoma:  "3317b7995b649ce76f5925339bbbce3c2073bec6da69b52a64903998c8ecf71c"
    sha256 cellar: :any,                 sonoma:        "3c69cb5f89280efb353fb184108c5d6e01c681e4e8149bcaf05f16f5ee200a6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ce47f3ed245c3941dc17e177599cc29288f4dc3c7692cdbe5ae5465ea7b60d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b5bb6effff27f51e922cc9a05dfb2689a721b7474dc53965c70371de6e9da3"
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
