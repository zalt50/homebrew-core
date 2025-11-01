class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.9.tgz"
  sha256 "17df6ca148204259565b333cdcc7e5a57c731d8806f093c579f37cdd89342354"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "dcd276260f708760d033b3dbd520f7429bccf0d153d1ce8dce84c6848441f1b2"
    sha256                               arm64_sequoia: "dcd276260f708760d033b3dbd520f7429bccf0d153d1ce8dce84c6848441f1b2"
    sha256                               arm64_sonoma:  "dcd276260f708760d033b3dbd520f7429bccf0d153d1ce8dce84c6848441f1b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3043139483220cd57e526db27c5723c1cedf33d3048b1a9d20114f1e26a1ba4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9742e5a480ed57a303501cda20a1003bedda88ee1d6de542a16aefd6f922d8c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089e0692354a3d1830cb40cbefd302dd90df75657da954bcdf37064413e94d92"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end
