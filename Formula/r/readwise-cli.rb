class ReadwiseCli < Formula
  desc "Command-line interface for Readwise and Reader"
  homepage "https://readwise.io/cli"
  url "https://registry.npmjs.org/@readwise/cli/-/cli-0.5.11.tgz"
  sha256 "d1d3fca556693813e6d38acab1346340625537d3c76642ef5d53dd4e6f8c390c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c15d6ef3c7ce6624b8e2e0ffedd024ed8ee3e8bc986ff2848aaaef33be14c26f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/readwise --version")

    system bin/"readwise", "config", "set", "readonly", "true"
    assert_match "true", shell_output("#{bin}/readwise config get readonly")
  end
end
