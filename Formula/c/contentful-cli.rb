class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-4.0.2.tgz"
  sha256 "8763c9bf7c45cbf953fd6be40309d9eef09034f1e2c960000ffa4401e74bd307"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b6f5e0b526e91281f8b6cf4b84967d332b87e33f59b9dec67b9712c1e551e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b6f5e0b526e91281f8b6cf4b84967d332b87e33f59b9dec67b9712c1e551e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b6f5e0b526e91281f8b6cf4b84967d332b87e33f59b9dec67b9712c1e551e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "37b6f5e0b526e91281f8b6cf4b84967d332b87e33f59b9dec67b9712c1e551e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37b6f5e0b526e91281f8b6cf4b84967d332b87e33f59b9dec67b9712c1e551e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09df3a1f24e599c2ada9b505d56eefb41bb78011913376dabebbc1fa6c89216b"
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
