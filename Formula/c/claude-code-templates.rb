class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.12.tgz"
  sha256 "672972de436cfe0cb691dea078526bb14229851a2a51fea062a587ba4bbaab7f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b4078b8cae42a2e02bbf008b05defe9edd5d486e3b110d056639cb4b7e053dd"
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
