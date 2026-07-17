class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://moonshotai.github.io/kimi-code/"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.25.0.tgz"
  sha256 "6eb5f93da0a4c24ad4b4648535f3bd577daab93fd4aa418707e7dee5ffa3ce90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ee4cf08407a2755a3cf8853a4a848399a59b8561381fd2d8fb1e058cf4de2aa"
    sha256 cellar: :any,                 arm64_sequoia: "2ee4cf08407a2755a3cf8853a4a848399a59b8561381fd2d8fb1e058cf4de2aa"
    sha256 cellar: :any,                 arm64_sonoma:  "2ee4cf08407a2755a3cf8853a4a848399a59b8561381fd2d8fb1e058cf4de2aa"
    sha256 cellar: :any,                 sonoma:        "19dbdd0214bef34352f69cd139eb04127963c04c341145cb61a73d3626894fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6922de017c3d98543a89a6dd394400657c7be60bf7473bb33befbf897d13b7b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92e6587a6abcd3888e9ab7252efb2dc4bf0624a72a6193b54faf172b0ecf908"
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
