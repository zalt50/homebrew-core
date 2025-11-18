class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.72.tgz"
  sha256 "c662422a66d52a66d338eff1a204fd20a329bcf321dc17fdbce3fd62213657ad"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "06b74a320707cfce94e04beae3bac225cef83657d0143e76ac647843ef369a10"
    sha256                               arm64_sequoia: "06b74a320707cfce94e04beae3bac225cef83657d0143e76ac647843ef369a10"
    sha256                               arm64_sonoma:  "06b74a320707cfce94e04beae3bac225cef83657d0143e76ac647843ef369a10"
    sha256 cellar: :any_skip_relocation, sonoma:        "04f4020ce9233f722108ec1ee7b1fdbc0c48aab5e526faa2fd66117246e5d843"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a8a053bcc25f78e40af7354bec84acf86523a1bdbd239cacee31d7345ee4a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ba642682c8b61cddc27a28bbdbc36d4bdec73f0a5e5bfcf41726788426b7216"
  end

  depends_on "node"

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
