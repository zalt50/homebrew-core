class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.1.270.tgz"
  sha256 "892b46947bdad073a59eaa2bdd7b4e9b445b42c2bbc403e5cb542f6c88ee2295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b2294f87f14a715cd17b4ef2a4fe00d2e74c7e869009684c90e25db34b99a3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b2294f87f14a715cd17b4ef2a4fe00d2e74c7e869009684c90e25db34b99a3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2294f87f14a715cd17b4ef2a4fe00d2e74c7e869009684c90e25db34b99a3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b43485923665383b914d7cff2a19212d73189db7a8d44e95e6520f2356b2d49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811bc451a7c9c94aabf1e79afa9f5ec94e7f3aa5416c15bdeacf29d2f38f4070"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70822311e608640ee641d8dfa71989742408d548f59f77ef93238d48170ee66f"
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
