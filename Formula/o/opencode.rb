class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.220.tgz"
  sha256 "c4bf1790626001477af0c1feca476c53091e351bccfa0585c1e8c47c0bd57b70"
  license "MIT"

  livecheck do
    throttle 10
  end

  bottle do
    sha256                               arm64_tahoe:   "96f469cf4dbda07ff1987c4252275af1fc9d1eff7a6f375e1754d5f1cc57e5af"
    sha256                               arm64_sequoia: "96f469cf4dbda07ff1987c4252275af1fc9d1eff7a6f375e1754d5f1cc57e5af"
    sha256                               arm64_sonoma:  "96f469cf4dbda07ff1987c4252275af1fc9d1eff7a6f375e1754d5f1cc57e5af"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb01294ac08a9c3c10fa40aa0d316e867558a8591cb0995e82856c7ab01e783a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024bf2a7af1dc060eaf1497645fce9293880a158b1186587389ee0c80dc6593c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d96a145b58e4d4a6f620fdb5ee079c8b60a7b8f6650350e07d2e89df4c86ea"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
