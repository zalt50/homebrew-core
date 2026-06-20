class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.12.2.tgz"
  sha256 "79e15374317897902f9aef41ecd3d072c3087c321cac9425b20a763e1f73ceb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc34afd900e0c67253359b0bb1e07fba3b3c6478ca13e6ecff59a52e07fe738d"
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
