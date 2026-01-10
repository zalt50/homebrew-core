class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.4.3.tgz"
  sha256 "eae120f1f900307fc3b5f61ee59708a675d183c2b6e1719e2c291968604bc6eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "624c671149b3692128e380ab3e156c692d872b3ab0a273639afa35d51e4c6b81"
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
