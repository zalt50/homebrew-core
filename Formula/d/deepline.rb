class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.284.tgz"
  sha256 "0fe03fe649852fd07a1f7fd91bfcec04a957c2f0d58c05dd1e3979225471484a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecb87db941d729c3476617a0d8c2b6c46df65cb94e42e1f72dbf86b3fc620327"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecb87db941d729c3476617a0d8c2b6c46df65cb94e42e1f72dbf86b3fc620327"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb87db941d729c3476617a0d8c2b6c46df65cb94e42e1f72dbf86b3fc620327"
    sha256 cellar: :any_skip_relocation, sonoma:        "220a8f6a5ab24d1faef7d35f22b6e2bba3db352d7fab75b0e5b1e9c883362665"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b0ebe9720ac51d6d7bce8320b7e5a310bc6154250a8c5d67c3cdf2fabeb025c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b7d3c2d915e130876ffc0add561547eab45ab268ac397cc88ad791bc5215136"
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
