class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.36.0.tgz"
  sha256 "f51c3b9c9243302517c9eb7d09a598a9b2693f1ec09b035c3272a5fc6a186fb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1f4861bedb4d7a352c026010c1db6ef2cbd718aaa061f4dc0de5f0d634512614"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f4861bedb4d7a352c026010c1db6ef2cbd718aaa061f4dc0de5f0d634512614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1f4861bedb4d7a352c026010c1db6ef2cbd718aaa061f4dc0de5f0d634512614"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c9817b09c687d040f952d0881820ba014a5630b1fac82d4dd90a138a9aab8aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c9817b09c687d040f952d0881820ba014a5630b1fac82d4dd90a138a9aab8aef"
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
