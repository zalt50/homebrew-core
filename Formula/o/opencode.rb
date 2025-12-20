class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.176.tgz"
  sha256 "286fb62973a70a7e67ea77b47ad578712e1821d03b701d342defbec5e796c950"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "5b598ee0d95c23db9ba3b0e0e0802a77617a9d558fd1f723ae23836c63091b09"
    sha256                               arm64_sequoia: "5b598ee0d95c23db9ba3b0e0e0802a77617a9d558fd1f723ae23836c63091b09"
    sha256                               arm64_sonoma:  "5b598ee0d95c23db9ba3b0e0e0802a77617a9d558fd1f723ae23836c63091b09"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff00a0078c64c5fe50a262bfc102288a98ae83648503a445065423e60bcb7547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6eb4f6c1ce6ffd517f8200c9f695971e985d07c74eecc7302047e9c8295fa3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d73f26ced27e73bdaf8354e3e33a0de1de88a0adf0aa557d42640bf67988e09b"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
