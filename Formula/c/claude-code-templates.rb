class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.9.tgz"
  sha256 "bc326fa63f21c639723a605e23e312e623a4acd2acd72ed202453bf624ba0618"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f46a50a9c5eba4455d239df6caff5e280feaa1da8acb4ef254f3b4ca41b2b77"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cct --version")

    output = shell_output("#{bin}/cct --command testing/generate-tests --yes")
    assert_match "Successfully installed 1 components", output
  end
end
