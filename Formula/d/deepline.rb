class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.283.tgz"
  sha256 "81a92369f0ca17c9672576a4526c06b5d8c4dd6c63116694167d09b4c28f1ec8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7348887e15c8c5c3ecdff0b6d2d56c209f56b13993fe19c8c22e2d31e71c75e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7348887e15c8c5c3ecdff0b6d2d56c209f56b13993fe19c8c22e2d31e71c75e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7348887e15c8c5c3ecdff0b6d2d56c209f56b13993fe19c8c22e2d31e71c75e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a362c516ae5ecdf5c512e2f4f8087fd591506ebbae862a1fec9c6eb305dd9480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "149cf8f7e6de9078f18ca7317ec9c43b61e7cce8dab35dc63a7051723f160420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b5cc139371e998ed3e054196a340ee52df70d359efd1299f0f42e9f43596305"
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
