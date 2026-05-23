class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.10.2.tgz"
  sha256 "63e1afbd4877987fdadd9dbac5573d980b92b8c81802b3ee0535ae67316985d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6424ea30bacb1ef0d9b88b3b67b51268e0cdf5544526ecbc92ca53db038ea871"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
