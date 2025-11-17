class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-42.12.0.tgz"
  sha256 "31c0fbccdd0a793350c9c050afc422a632116b90e9f0440d04dded8efd389d38"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8453f181116e946dc79ee245dd3fd576e905ba9a3071a08a92fa85f6f97ca49d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de1da08540426e070de97aacb7af3c0bec0459fe0a5ad52dead9844438e71c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c7f2bd65e3417b5c9c5132a51e02b353e74b992ff1356a6874552f25094f757"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcfdd44bc07a84057403a71b356320341e787c613dbd5a7e50644db6c00edd6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd8ccb36c590ff0ccb56f987c38cdc74e5b61f7d731511de7568a2f38e9b0ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "736664fc180714ce3b913339a1746a56a6b1c1a87086515abc41d0e698606838"
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
