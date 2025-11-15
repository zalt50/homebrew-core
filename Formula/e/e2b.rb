class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.4.2.tgz"
  sha256 "0eb29751b38c7e4b3c613b7e18c1e772a14bb3acf192231fb9aba2e64d228bf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "43bbe13031cde4dee09ffebd2b31913046b5f06662d789b20736d61ec036de36"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end
