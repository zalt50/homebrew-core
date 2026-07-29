class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.297.tgz"
  sha256 "1e7d2eed839c5bc58e0c557c44e05b005d6c301189bf08276e0b9a63c5b58178"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95328d85316a9b73f533aebe0cb82ce134b77767ee68800782e21bc8f9453bcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95328d85316a9b73f533aebe0cb82ce134b77767ee68800782e21bc8f9453bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95328d85316a9b73f533aebe0cb82ce134b77767ee68800782e21bc8f9453bcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ed67c8efa2017b9dd5adfe42c0414664e766d5ab7489c4c659c5b736f837211"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa9f36074dc0f8763896685d3291f658aca9cb264697acd1258c36d2a75d3af8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f7df971d343e8ed1ec0a7b34302d01cf1f6fcb2a79f11a38c2e41fd12bd82e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end
