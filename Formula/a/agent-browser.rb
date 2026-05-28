class AgentBrowser < Formula
  desc "Browser automation CLI for AI agents"
  homepage "https://agent-browser.dev/"
  url "https://github.com/vercel-labs/agent-browser/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "d4428ba7af210e5816aa72b8ed83a84396755ba94770da7118f611a30fd9286f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e0f808456913dfaf48c0129c82f2438dff6e1d7aec079ce444df19c72ce0ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e0f808456913dfaf48c0129c82f2438dff6e1d7aec079ce444df19c72ce0ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0f808456913dfaf48c0129c82f2438dff6e1d7aec079ce444df19c72ce0ae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b73c3bfc489759cb4482d8d9d9e1168d9539b5a8c5c49a67e6ea2fe69e078f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09c3bc48fdea62e01350c0ddc28eee848821cedc9d3566f65fb30064199b0730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a58120651050148698a8ce2934587d0838751fb17a4b4e4daf16190bb1d7450"
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
