class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.171.0.tgz"
  sha256 "5415dba7b80b55cb88eca9e55def5216ee3cedf86c856c22a49d87cec79c2429"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5f42bb2b7f2af522d48707b381529d610bfd214c04b136b00affdc17b8954be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a4fd5d0815986f7ee931450660d0e0756994748f1acc7f855034ce970cde57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f53f0e121e8b5a46cd80daea88fc77aeee3d3e729adbd465b836d221444ec3e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4da926d67e5901f8a7d20f57b6300590ff04b06d84bb8dca2a91c46ab7a868f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dacb7df4a3e00c3407664609180f7d892a34d15d2ba151968cf06fdd5cf3ac9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c6d7d613d61e9a7caf1553d982e36528474a4d5bdbbbb9127a9bbcfa330b02"
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
