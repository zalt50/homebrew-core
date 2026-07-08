class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://www.contentful.com/developers/docs/tutorials/cli/"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.3.tgz"
  sha256 "931b64ad065d5adb4134d4878748b0e86510ee37877a57897269ccbf2dc7c1c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68f7b1f17e0246204f14f2c1a68e621b2c5a46c07caa1f8c2443739b59b2d162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68f7b1f17e0246204f14f2c1a68e621b2c5a46c07caa1f8c2443739b59b2d162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68f7b1f17e0246204f14f2c1a68e621b2c5a46c07caa1f8c2443739b59b2d162"
    sha256 cellar: :any_skip_relocation, sonoma:        "68f7b1f17e0246204f14f2c1a68e621b2c5a46c07caa1f8c2443739b59b2d162"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68f7b1f17e0246204f14f2c1a68e621b2c5a46c07caa1f8c2443739b59b2d162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c863fc57d737708238e18edc1fe60094f92b2a52b6c1ea075cfa41b5539be75d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
