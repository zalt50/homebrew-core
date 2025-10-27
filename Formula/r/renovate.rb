class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.160.0.tgz"
  sha256 "4a878369caf5da7e8064f1304abb277ae9c984ee1bf6d96fc454b2a1a8ff7243"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c91df723bafa571deaea7316ffb9d97f243f46494e5651d2c9121b6be73b2564"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d974b09c8641e183c881bb83a482da1687fe54b1ba1aefd397f33308b16bd7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33a686b7c3892b79efdfa91489ccbd780747870ae77d2edf4cfee76af6725a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a89d4dbd9a8402073f24cca19c2fbbe66c8b3079ec2dd3e3bc43e9cf7d9d442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7df2581836b53247bf37df4fd0a94335e72f97ae2c076afbc0bf3fc85ee069f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3f7a9b77311a8b615604bee0dbcbc5072ec3ca1e3bd193db2e2c8d4a73e44aa"
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
