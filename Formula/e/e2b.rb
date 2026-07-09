class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.13.1.tgz"
  sha256 "9eb2c97da151f768d465faecfb0ff00a3dd8fcac31145934a730f12fa32089ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fd065054e776902e44fb2bbfbbccbdbefa687e9257d04c7a1553094fa23241f"
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
