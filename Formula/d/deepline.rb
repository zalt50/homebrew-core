class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.288.tgz"
  sha256 "7b4bf99651b150833c40ffb85466180e7c5ee4ed9948a0e46e675316a6579a38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a86ae9c1d2c5518583d8828f2c2d84b11ed358c9c4d5e80dd09464991e8eb16f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a86ae9c1d2c5518583d8828f2c2d84b11ed358c9c4d5e80dd09464991e8eb16f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a86ae9c1d2c5518583d8828f2c2d84b11ed358c9c4d5e80dd09464991e8eb16f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce0bcf8674ffab1ad384265cb276b7328a1818c500a284a765e4c1f84bb5509d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0422c431207b984ea7f63a78000a835cc3e4e8676ffd3ead066cb89ed5f29762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25a59604a2c2973b3fb81da6e1b732ab47d2320da1f91b282ac402895b0346d4"
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
