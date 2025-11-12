class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.7.0.tgz"
  sha256 "39978c21709a79951f5ba438a89df39821d0d03be36b9622b93ce24b9aae96d4"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ad9ac40afd2ea481eeed4a4145dd7a4b52811a1783ebbc72c7524980cfaf52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9759b4cb149b8120566ce2bd1695f5e50a46524977da4a62f115c3b7e86eb69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a62e8ecf24729947b9a80aa1db7d30675dae2711216af0266fda7016e233ee4"
    sha256 cellar: :any_skip_relocation, sonoma:        "33ac32ef26b746e0a70a20fc972d091f38101b5b4ecb3a30e508dac96f35196a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a99f0b4c995be26526ab03de8baab8311dd2659fd3a88490346332e6c8ee65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed1473aa6dbd3a46072221d21179894c2e1dfd61f8baf4a08a8e90dd8688ffae"
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
