class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.133.tgz"
  sha256 "188ee074a9b3d575199e3a3c882d512fd0b7f9385ae1c38a065c93922a6b977f"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "cefc4b9f6d4f6d2a062530f2fb0d7c2ad4e818b1fec23e0a06b543ec9772769a"
    sha256                               arm64_sequoia: "cefc4b9f6d4f6d2a062530f2fb0d7c2ad4e818b1fec23e0a06b543ec9772769a"
    sha256                               arm64_sonoma:  "cefc4b9f6d4f6d2a062530f2fb0d7c2ad4e818b1fec23e0a06b543ec9772769a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3278e87b0b0305503f647a9a222856202b74c134412bf2463d8cbba9d35d9139"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "369f594a123b5206bdbfc04570843983094fbe4c53280733d0270776b026c1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eab3dbc76e8c217d2bcc1db40fe89cac75125fdd441559145be9d509704dda5"
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
