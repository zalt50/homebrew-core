class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.68.tgz"
  sha256 "866c8b3d4e12844e90d2a88f9c4ef97dbd11b25aaab0973fe5523f7deb94485e"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "e82d101201701eedc84b0b22fe501ea37cb5c37df4a21b4648cf0f71c921ce2f"
    sha256                               arm64_sequoia: "e82d101201701eedc84b0b22fe501ea37cb5c37df4a21b4648cf0f71c921ce2f"
    sha256                               arm64_sonoma:  "e82d101201701eedc84b0b22fe501ea37cb5c37df4a21b4648cf0f71c921ce2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "56e8673f03a59eae521347b462df3497ce49ef24dc761771cf5f08676a54028b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fb60181c6757fc1c4cd362b6a20450275da3e5475407977dec4c26862e0ec5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e58f1d5e66f23eabe80a1480b0f20d5289294fe5313a62fe0b52becc0c10074"
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
