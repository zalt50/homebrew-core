class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.32.1.tar.gz"
  sha256 "a63703b7a38f695df69f7a5dc25f0762ea32b0ca6794ae830b1591b7217c649c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66f0a004ff273c8b95045918f4890d62488a4e212fff8012af80995b8ba8f412"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906191c363a59ecb42517e0b2cdf9a627ac6b93793c077c552754452b4c798de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8777df0bdb68dcfb18388cb7f92e9c1854db77139a7223ec7422203f04f8dde"
    sha256 cellar: :any_skip_relocation, sonoma:        "32de36b268ca53e9178d3fd64a7d3359f8033623cbd89d7d55747edf4fdbb7de"
    sha256 cellar: :any,                 arm64_linux:   "261d7c3f1f16d40e4764db411e9ab094385928f66bdba73d19e50c40648798e1"
    sha256 cellar: :any,                 x86_64_linux:  "f425e5f8cbff16f96aa646729c0ba0d043ae4f5da22787e7b9edf2d589f2a3d8"
  end

  depends_on "rust" => :build
  depends_on "node"

  deny_network_access! [:postinstall, :test]

  def install
    system "npm", "run", "build:native"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  def caveats
    <<~EOS
      To complete the installation, run:
        agent-browser install
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agent-browser --version")

    # Verify session list subcommand works without a browser daemon
    assert_match "No active sessions", shell_output("#{bin}/agent-browser session list")

    # Verify CLI validates commands and rejects unknown ones
    output = shell_output("#{bin}/agent-browser nonexistentcommand 2>&1", 1)
    assert_match "Unknown command", output
  end
end
