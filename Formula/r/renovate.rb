class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.168.0.tgz"
  sha256 "979903c86eaca01e8ceac84ba98339f18b18d0593d3a07a16f038509d5f4807a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "895ae6be697feb964f6a64525cbe435e3da7da1972e2bd5ad4993b6ad71dbc50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cc4e0e0552ca5736ba71063ce00a0d4936263dc30a0a4c20170ab508176b624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf39ad69b460696da8e68dda5aec458721cf68b0a0d98921d58cf22317db10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "89e8dfbe291d4cda34db280fc5df346705dd19f84d8b44c89b466e4da4e4edad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a868bc50cebad138d60dad9f9f275ae0a17388a75e5c6f1baed132ddd45586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae71c2047d2a1d5ce68ddbc2a039785a02ca12ce29c7d9043054f0cc4e272f3"
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
