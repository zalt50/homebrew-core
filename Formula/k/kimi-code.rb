class KimiCode < Formula
  desc "AI coding agent for your terminal"
  homepage "https://github.com/MoonshotAI/kimi-code"
  url "https://registry.npmjs.org/@moonshot-ai/kimi-code/-/kimi-code-0.12.1.tgz"
  sha256 "16a18aeefd3ddbb99399dd4f1c882d05996ea1744bccf36db1aeb887cd1851f6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9e3dfc43d2437fd382cc817d5059b240bc7b20ff49522e72d5aef15ee5deeb53"
    sha256 cellar: :any,                 arm64_sequoia: "262a490a35e2ab01622758e0b5b1b8457d31ae8b9d7f5ae30ec2b855e0d77a88"
    sha256 cellar: :any,                 arm64_sonoma:  "262a490a35e2ab01622758e0b5b1b8457d31ae8b9d7f5ae30ec2b855e0d77a88"
    sha256 cellar: :any,                 sonoma:        "75419ac1903088161b3dcd4c0b27771094a9c3f7430a2b317684e82ea79c269e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e74a6327be5382f06a7cb905a527951bac96a4a8ca93f5663b77a84df287d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "128defc253abdd8437d54be78401161aa0fefa845d89ed0312d38aaa4b8f9f87"
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
