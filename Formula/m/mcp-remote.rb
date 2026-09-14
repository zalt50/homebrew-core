class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.14.0.tgz"
  sha256 "b5c5930983d2ecae62fa90d932a36baabb6bc105bb201dd312949a2283e9b131"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43e9eadd24791244f1e61b9e0235204dbabceaa1b2c8c8267d5bbf8efabf610a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end
