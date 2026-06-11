class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.11.1.tgz"
  sha256 "8c44935c9c6d9749852204046bbd3d737c27d812d81c1aded63f0993ec9ffcc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "862649b07e3a39719c669bd783b34cd7361e21dfbd4196f73afd22cae525fa9e"
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
