class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.172.0.tgz"
  sha256 "1d26c6a358592a7068f540d62f6b10bbc31a4443b977abb7cb76e02724657786"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f7dc266dade42c9a272bf95ad04d32fb3f785bc25d76ef2862b4be6cc47b9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c27f986fa97181e6fb86715378c5d2fc1bc5910f18aebe620f3b8f274f985be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01aae03afe75ef7b3f32168950adf462446137a92f7a036b41eccb8db5c875fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8b609dc224b18c1eaea48bc2c356849531b89939ce4221929c0d92fb1882ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d12cffaad922a16842f2e898f5590c7bc34aef3ba3708993760ef9c307a61618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35d5b9be59b7f45e01a907236408094aa1c22e011676513495591a1d35ff8216"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end
