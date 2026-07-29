class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.302.tgz"
  sha256 "465d8d945c6d89b8dc56a92eb749a57e79fbacd7229581591bdafff0bc8757c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7190242fde026bbb33baed849c3aafd1e89923cfde952c39e4224c2531c01f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7190242fde026bbb33baed849c3aafd1e89923cfde952c39e4224c2531c01f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7190242fde026bbb33baed849c3aafd1e89923cfde952c39e4224c2531c01f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "24683a9f9d5e612ba1884f8098233167390adf2929f7a6596f0775d77bfe9f95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68917fe256e2da981029b2f1fdfa0be2213f9584ffe4329eb92e3df9990fa311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f08b5aa7233293f8fdf659042d537495335e064f5331578c85701653789185e"
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
