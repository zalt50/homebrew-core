class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.13.3.tgz"
  sha256 "d1403fbb6dbffddcd19967c0f1e54cc9324c29518387595025f19f4cac84b00a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac3208f3e18567fb42ef27ece6d5a54cf680d2f6c8701acf004a97fddaa8cf32"
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
