class ClaudeCodeTemplates < Formula
  desc "CLI tool for configuring and monitoring Claude Code"
  homepage "https://www.aitmpl.com/agents"
  url "https://registry.npmjs.org/claude-code-templates/-/claude-code-templates-1.28.5.tgz"
  sha256 "fb1fe8a7f261d9925b6944da02939c64475789b7834f499efadad8dc38f8956d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a03fa2f92ac53d7efc6b7c6f77d7aa10eebe892fd423d525169574a507651253"
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
