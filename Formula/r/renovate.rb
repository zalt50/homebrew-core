class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.17.0.tgz"
  sha256 "dc2a0e8afd9cfb20f6bffb52d9a797e7ee001cb297253577b2d05d5f9080c602"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f45269cac67dd212c8f250e6f2662944bff1d62a21d3a991b831674294d0cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66441324cf4c3382e9824d1a02cd1ce60fecc4b11457d421e28232a9d804aa5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7f88a99bb9d5d499eee9e3c6ea65ff78649d195d1aed508da0814dbdf7f203"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dbd1faa17316118b98f938a727fcf7476c703351201f11e8280ee3292bca375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1845af06022f4b9396157449ea855c913134651a8148eaa4fbcd9ba97041e476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "876382cf9ede8758fa7aa1c9f220487f388fa9d5491fc99df676c83041bc6a8d"
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
