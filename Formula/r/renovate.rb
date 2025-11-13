class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.9.0.tgz"
  sha256 "d95b1179c17acecae1251f0479d6fab817be168cd4db26024e4879e0e8caa091"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f5da2e16916366ba5224a9f6c2b84d956fd8705ecbbb6ad8db821621cbff744"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "165e01bb97e53b9e8f469996a65a6e2da23c365705fd61b8f78ad8b15b92f489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5db09e5a83407bd8dc95085ebeee731551c61cff645959895d74e354b10798e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f71bf050015e4aefbcd1d866ab0883222fa54ab928a19b613ab81a88afd8aa6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6047a6174f683a49535dabeefa6aaadc1fb8922159330c39b00b37956cc06ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29251d8bb94ecca0fd88da0dedbc02b0f7ea14ab79ae2ccf45cfe11d8ef4e923"
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
