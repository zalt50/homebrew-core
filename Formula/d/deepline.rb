class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.288.tgz"
  sha256 "7b4bf99651b150833c40ffb85466180e7c5ee4ed9948a0e46e675316a6579a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "308d69b0903a3512e4af44eea53feabf0c7746fedd0e267f03bc4205493d2d0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308d69b0903a3512e4af44eea53feabf0c7746fedd0e267f03bc4205493d2d0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308d69b0903a3512e4af44eea53feabf0c7746fedd0e267f03bc4205493d2d0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f5b269b4ab286d564f890538055edcb797dd59eae366ae428642b81f966ec37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d27e0ccdbe8b8d2448ee5ba879aec5d0c60196ae9c16c8055ed90e2a1d84e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d568bd96c1c3f734aa33f22718510430dec470eda7cb6395c954065b090eb1"
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
