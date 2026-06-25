class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "9941b626833c9cb72a5594c94b58e0490c6fb7c7fc1d1dbe492ead36324fd752"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86ec847037b8a321346c79dd9a84a070b7af6152356f82cb46262449613d6c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9269e232f353ece8991b4546672b008c4ad51ece154909fe46c277908b17654f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "022223ec5cd158bc6d2401c755d1da9268e29d0921604ea520d40146e2bda3e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "79c656189f35b06aac441d587cbd8ac227e682d2ee14479daece4a826213af76"
    sha256 cellar: :any,                 arm64_linux:   "3651cbb5546931dde508339ae2ada01d2123130ccdcb09fff2eb6eb4328b5b51"
    sha256 cellar: :any,                 x86_64_linux:  "2815fd88e5183560c365d9671260c5da3d519ce8aaff874ca1f786180841881e"
  end

  depends_on "rust" => :build
  depends_on "node"

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
