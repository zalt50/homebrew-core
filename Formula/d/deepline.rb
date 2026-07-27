class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.281.tgz"
  sha256 "2669e16ec1e081acf546d7dc7e59204bbed1ace6b49753ec4408fda615b4dc86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b976e8c0cb74e6c02fb00a5c715d8335c6f070e45a0ef1363db285bbd6d76f9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b976e8c0cb74e6c02fb00a5c715d8335c6f070e45a0ef1363db285bbd6d76f9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b976e8c0cb74e6c02fb00a5c715d8335c6f070e45a0ef1363db285bbd6d76f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1ab103d2cff5bc303857012c5f03b37e27152bb39d53156cb99447196c62c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45b10def89d20e0197aafa6200fb4a3dca05093e4894d8608db266ccab04c7ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55aa7ec9310b47c17297fdd8bbe22aee8d4c2b6f723a31f4f1e27d3c6eade6b8"
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
