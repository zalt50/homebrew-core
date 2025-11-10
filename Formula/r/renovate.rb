class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.4.0.tgz"
  sha256 "33187990d363bf21534335d0b4d4808e4ae50dfddb2415566766b908c06a9b97"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02ed84f11744ce9c2361f3d7a5fe96418608677f116e5fa024d7d20a96382166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc6316165fa6944d9ef4ff5445eef788602ca347ad1ff0ab3dc33df38dba0735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc3fe91cdbc38a9d69d6b2f6bd1f0643205696be860cc75ce11fcd285bb740bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "15dcb83306db0f27190957500fbeccf3403919df589cfcf771128d101d8de3db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6a00e950e4afde6aa09df749b665aa1e57135e5f011b533ad58314e32372a69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16492833ce27af1eaf2a4ebe2662a453a275aee0846b1ee4f1ea694180337a41"
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
