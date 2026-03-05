class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.14.0.tgz"
  sha256 "cd5a130cd1f3b9a6613500f1ea601874d62ae6e2be10b64e1d02df4a59c373a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5b42ee84c1b8ab2a8085ea337182a70678bb4a7fcf96458e5f1f1157e2474aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
